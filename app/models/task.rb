class Task < ApplicationRecord
    def self.from_json(json_str)
        Rails.logger.info "Received task:"
        Rails.logger.info json_str

        task_hash = JSON.parse(json_str)

        tasks = []
    
        if task_hash.key? 'collection' # Multiple tasks
            task_hash['collection'].each do |task|
                tasks << task_from_hash(task)
            end
        else
            tasks << task_from_hash(task_hash)
        end
        tasks
    end

    private

    def self.task_from_hash(h)
        Task.create(
            user_url: h['links'].select {|l| l['rel'] == 'user' }.first.to_json,
            task_type: h['type'],
            owner_url: h['links'].select {|l| l['rel'] == 'user' }.first.to_json,
            task_state: h['state'],
            target_url: h['links'].select {|l| l['rel'] == 'target' }.first.to_json,
            continue_url: h['links'].select {|l| l['rel'] == 'continue' }.first.to_json,
            cancel_url: h['links'].select {|l| l['rel'] == 'cancel' }.first.to_json,
            active: true,
            uuid: SecureRandom.uuid
        )
    end
end
