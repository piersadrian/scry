class SeedData
  class << self

    FILE_EXT  = "json".freeze
    MODEL_DIR = "#{ Rails.root }/db/models".freeze

    # Dumps the contents every model into pretty-formatted JSON in the given
    # directory. This lets us just make quick changes to the JSON structure and
    # reimport the data (using #load) directly into the database.
    def dump!(output_dir = MODEL_DIR)
      model_classes.each do |model_class|
        filename = "#{ model_class.name.tableize }.#{ FILE_EXT }".gsub("/", "-")

        # Open the output file and replace its contents.
        File.open( File.join(output_dir.split("/"), filename), "w" ) do |file|
          if model_class.any?
            records = []

            model_class.find_in_batches do |batch|
              # Only extract the attributes of each record since that's what we'll
              # use to recreate these records later.
              new_records = batch.map do |record|
                record.__send__(:attributes)
              end

              records.concat( new_records )
            end

            file << JSON.pretty_generate( records )
          end
        end
      end

      true
    end

    # Loads the contents of each JSON model-dump in the given directory into
    # the database, replacing any current data.
    #
    # CAUTION: THIS METHOD IS EXTRAORDINARILY DESTRUCTIVE! NEVER, EVER, EVER
    # RUN THIS METHOD WITHOUT FULLY UNDERSTANDING WHAT IT DOES.
    def load!(input_dir = MODEL_DIR)
      raise RuntimeError.new("You can't run this in production!") if Rails.env.production?

      Dir.glob( File.join(input_dir.split("/"), "*.#{ FILE_EXT }") ).each do |filename|
        model_class = File.basename( filename, ".#{ FILE_EXT }").gsub("-", "/").classify.constantize
        print "Importing table data for #{ model_class.name.pluralize }... "

        File.open( filename, "r" ) do |file|
          next unless File.size?(file)

          JSON.parse(file.read).each do |attributes|
            record = model_class.new

            # This approach unfortunately appears not to increment any sequences. That
            # means that the next INSERT will try to use a pkey that's been used already.
            record.assign_attributes(attributes)
            record.save
          end
        end

        # Here's the problem: STI models share a common table name, so even though
        # there are separate data dumps for each model, they really all go in
        # one table. The sequence number needs to be restarted for each *table*,
        # not each *model*.
        table_name = model_class.table_name

        if table_name == model_class.name.tableize.gsub("/", "_") && model_class.any?

          # This model has its own table, so fix its sequence.
          sequence_name = "#{ table_name }_id_seq"
          next_seq_num  = model_class.last.id + 1
          ActiveRecord::Base.connection.execute("ALTER SEQUENCE #{ sequence_name } RESTART WITH #{ next_seq_num };")
        end

        puts "done!"
      end

      true
    end

    def model_classes
      @models ||= begin
        # Ensures that Rails loads and caches all classes, including models.
        Rails.application.eager_load!

        # Now grab the list of all loaded models.
        ActiveRecord::Base.descendants
      end
    end

  end
end
