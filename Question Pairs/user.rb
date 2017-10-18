require 'sqlite3'
require 'singleton'

class User < ModelBase
  attr_accessor :fname, :lname

  def self.find_by_name(fname, lname)
    user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname LIKE ? AND lname LIKE ?
    SQL

    return nil unless user.length > 0

    User.new(user.first)
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def authored_questions
    Question.find_by_user_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def average_karma
    # number of question was liked / total questoins
    user = QuestionsDatabase.instance.execute(<<-SQL, @id)
    SELECT
      COUNT(DISTINCT(questions.id)) AS num_questions,
      CAST(COUNT(question_likes.user_id) AS FLOAT) AS num_likes
    FROM
      questions
    LEFT OUTER JOIN
      question_likes ON questions.id = question_likes.question_id
    WHERE
      questions.user_id = ?
    SQL

    data = user.first
    return 0 if data['num_questions'] == 0
    data['num_likes'] / data['num_questions']
  end
end
