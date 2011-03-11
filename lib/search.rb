module Search
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def search(query)
      ret_arr = Array.new
      col_names = self.column_names

      col_names.delete_if { |c| c == "id" }

      col_names.each do |col_name|
        results = self.find_by_sql("SELECT * FROM #{self.table_name} WHERE #{col_name} LIKE '%#{query}%'")
        ret_arr.concat results
      end
      ret_arr.uniq!
      return ret_arr
    end
  end
end
