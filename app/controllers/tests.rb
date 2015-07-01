class Tests < Application
  def index
    @tests = user.tests
  end
end
