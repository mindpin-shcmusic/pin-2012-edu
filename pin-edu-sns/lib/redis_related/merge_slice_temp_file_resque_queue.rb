# VVERBOSE=1 INTERVAL=1 QUEUE=merge_slice_temp_file_resque_queue RAILS_ENV=development rake environment resque:work
class MergeSliceTempFileResqueQueue
  QUEUE_NAME = :merge_slice_temp_file_resque_queue
  @queue = QUEUE_NAME 
  
  def self.enqueue(slice_temp_file_id, file_entity_id)
    Resque.enqueue(MergeSliceTempFileResqueQueue, slice_temp_file_id, file_entity_id)
  end
  
  def self.perform(slice_temp_file_id, file_entity_id)
    slice_temp_file = SliceTempFile.find(slice_temp_file_id)
    slice_temp_file.merge_on_queue(file_entity_id)
  rescue Exception => ex
    p ex.message
    puts ex.backtrace*"\n"
  end
end