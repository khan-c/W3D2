require 'sqlite3'
require 'singleton'
require 'active_support/inflector'

class ModelBase

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{self.to_s.tableize}
      WHERE
        id = ?
    SQL

    return nil unless data.length > 0

    self.new(data.first)
  end

  def self.all
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.to_s.tableize}
    SQL

    return nil unless data.length > 0

    data.map { |datum| self.new(datum) }
  end

  def self.where(options)
    search_items = options.values
    search_terms = options.keys.map { |key| "#{key} = ?" }.join(" AND ")
    QuestionsDatabase.instance.execute(<<-SQL, *search_items)
    SELECT
      *
    FROM
      #{self.to_s.tableize}
    WHERE
      (#{search_terms})
    SQL
  end

  def save
    if @id
      self.update
    else
      self.create
    end
  end

  def create
    var_names = self.instance_variables - [:@id]
    var_string = var_names.map(&:to_s).join(', ')
    var_string2 = var_string.delete('@')
    p var_string
    p var_string2

    QuestionsDatabase.instance.execute(<<-SQL, var_string)
      INSERT INTO
        #{self.class.to_s.tableize} (#{var_string2})
      VALUES
        (#{(['?'] * var_names.count).join(', ')})
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update
    var_names = self.instance_variables.rotate
    var_string = var_names.map(&:to_s).join(', ')
    var_names -= [:@id]
    var_string2 = var_names.map do |var|
      "#{var} = ?"
    end.join(", ").delete('@')

    p var_string
    p var_string2
    QuestionsDatabase.instance.execute(<<-SQL, var_string)
     UPDATE
       #{self.class.to_s.tableize}
     SET
       #{var_string2}
     WHERE
       id = ?
    SQL
  end

end
