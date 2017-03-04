class SupplierInvoices < ROM::Relation[:sql]
  YmlType = Types.Constructor(Array) { |value| YAML.load(value) }
  schema(infer: true) do
    attribute :pallet_filter, Types::String, read: YmlType
    # attribute :status, Types::String, read: Types.Constructor(Symbol, &:to_sym)
  end
end
