class FeedUploader < CarrierWave::Uploader::Base

  after :store, :perform_import

  def perform_import(file)
    ActionCable.server.broadcast 'room_channel',
                                 message: "<a href='/sections' class='dropdown-item'>Registration data import in process.</a>"
    ImportWorker.perform_async(self.url.to_s)
  end

  # Choose what kind of storage to use for this uploader:
  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    nil
  end


  # Add a white list of extensions which are allowed to be uploaded.
  # Allow only Excel and CSV files:
  def extension_whitelist
    %w(xlsx csv)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
end
