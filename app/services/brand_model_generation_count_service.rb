class BrandModelGenerationCountService
  def self.call(compact = false)
    brand_model_generation_counts = fetch_brand_model_generation_counts unless compact
    brand_counts = fetch_brand_counts

    brand_counts.map do |brand_name, total_count|
      response = { brand: brand_name, total: total_count }
      response[:models] = format_models(brand_name, brand_model_generation_counts) unless compact
      response
    end
  end

  private

  def self.fetch_brand_model_generation_counts
    Car.joins(:brand, :model, :generation)
       .group('brands.name', 'models.name', 'generations.name')
       .count
  end

  def self.fetch_brand_counts
    Car.joins(:brand)
       .group('brands.name')
       .count
  end

  def self.format_models(brand_name, brand_model_generation_counts)
    brand_model_generation_counts.each_with_object({}) do |((b_name, model_name, generation_name), count), models_hash|
      next unless b_name == brand_name

      models_hash[model_name] ||= { name: model_name, total: 0, generations: [] }
      models_hash[model_name][:total] += count
      models_hash[model_name][:generations] << format_generation(generation_name, count)
    end.values
  end

  def self.format_generation(generation_name, count)
    { name: generation_name, count: count }
  end
end
