class SupplierInvoices < ROM::Relation[:sql]
  YmlType = Types.Constructor(String) { |value| YAML.load(value.inspect) }
  schema(infer: true) do
    attribute :pallet_filter, Types::Array, read: YmlType
    # attribute :status, Types::String, read: Types.Constructor(Symbol, &:to_sym)
  end
end
