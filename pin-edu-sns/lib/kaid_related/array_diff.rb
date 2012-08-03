class ArrayDiff
  def initialize(params)
    params.assert_valid_keys :new, :old

    @new = params[:new]
    @old = params[:old]
  end

  def added
    (@new - @old).sort
  end

  def deleted
    (@old - @new).sort
  end

  def intersection
    (@old & @new).sort
  end

  def union
    (@old | @new).sort
  end

  def merge
    (intersection + added).sort
  end

  class << self
    [:added, :deleted, :intersection, :union, :merge].each do |method_name|
      define_method method_name do |old, new|
        ArrayDiff.new(:old => old, :new => new).send(method_name)
      end
    end
  end
end
