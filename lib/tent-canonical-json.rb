require "tent-canonical-json/version"
require "json-pointer"
require "yajl"

class TentCanonicalJson
  REMOVE = %w[ /permissions /received_at /version/received_at /version/id ].freeze
  REMOVE_MATCHING = {
    "/mentions/~/public" => false
  }.freeze
  MOVE = {
    "/original_entity" => "/entity",
    "/mentions/~/original_entity" => "/mentions/{index}/entity",
    "/refs/~/original_entity" => "/refs/{index}/entity",
    "/version/parents/~/original_entity" => "/version/parents/{index}/entity"
  }.freeze
  REMOVE_EMPTY = %w[ /app /attachments /mentions /refs /content /licenses /version/parents /version/message /version ].freeze
  REMOVE_MATCHING_PATHS = {
    "/version/parents/~/post" => "/id",
    "/version/parents/~/entity" => "/entity",
    "/mentions/~/post" => "/id",
    "/mentions/~/entity" => "/entity",
    "/refs/~/post" => "/id",
    "/refs/~/entity" => "/entity"
  }.freeze

  def self.encode(post)
    new(post).encode
  end

  def initialize(post)
    @post = stringify_keys(post.dup)
  end

  def encode
    cleanup
    sorted_encode
  end

  private

  def cleanup
    REMOVE.each do |path|
      pointer = JsonPointer.new(@post, path)
      pointer.delete
    end

    MOVE.each_pair do |path, target_path|
      pointer = JsonPointer.new(@post, path)
      next unless pointer.exists?

      if path =~ %r{/~/}
        pointer.value.each_with_index do |value, index|
          next unless value
          target_pointer = JsonPointer.new(@post, target_path.sub('{index}', index.to_s))
          target_pointer.value = value
        end
        pointer.delete
      else
        target_pointer = JsonPointer.new(@post, target_path)
        target_pointer.value = pointer.value if pointer.value
        pointer.delete
      end
    end

    REMOVE_MATCHING.each_pair do |path, value|
      pointer = JsonPointer.new(@post, path)
      next unless pointer.exists?

      pointer.value.each_with_index do |pointer_value, index|
        next unless pointer_value == value
        delete_path = path.split('/')
        delete_path.pop
        delete_path = delete_path.join('/').sub('*', index.to_s)
        delete_pointer = JsonPointer.new(@post, delete_path)
        delete_pointer.delete
      end
    end

    REMOVE_EMPTY.each do |path|
      pointer = JsonPointer.new(@post, path)
      pointer.delete if obj_empty?(pointer.value)
    end

    REMOVE_MATCHING_PATHS.each_pair do |path, other_path|
      pointer = JsonPointer.new(@post, path)
      next unless pointer.exists?
      other_pointer = JsonPointer.new(@post, other_path)
      next unless other_pointer.exists?

      pointer.value.each_with_index do |value, index|
        delete_pointer = JsonPointer.new(@post, path.sub('*', index.to_s))
        delete_pointer.delete if value == other_pointer.value
      end
    end
  end

  def sorted_encode(hash=@post)
    sorted_keys = hash.keys.sort
    encoded_values = hash.inject({}) do |memo, (k,v)|
      memo[k] = case v
      when Hash
        sorted_encode(v)
      when Array
        json = v.map { |i|
          case i
          when Hash
            sorted_encode(i)
          else
            Yajl::Encoder.encode(i)
          end
        }.join(",")
        "[#{json}]"
      else
        Yajl::Encoder.encode(v)
      end
      memo
    end
    json = sorted_keys.map do |key|
      "#{key.to_s.inspect}:#{encoded_values[key]}"
    end.join(",")
    "{#{json}}"
  end

  def stringify_keys(hash)
    hash.inject(Hash.new) do |new_hash, (key, val)|
      new_hash[key.to_s] = case val
      when Hash
        stringify_keys(val)
      when Array
        val.map { |v|
          case v
          when Hash
            stringify_keys(v)
          else
            v
          end
        }
      else
        val
      end
      new_hash
    end
  end

  def obj_empty?(obj)
    case obj
    when Hash
      obj.keys.empty?
    when Array
      obj.empty?
    when String
      obj == ""
    when NilClass
      true
    end
  end
end
