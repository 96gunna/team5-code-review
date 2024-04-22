# Define a Menu class that displays a set of options with corresponding numbers.
class Menu
  # Constants for menu options, frozen to prevent modification.
  OPTIONS = {
    '1' => 'Load input data',
    '2' => 'Check visibility',
    '3' => 'Retrieve posts',
    '4' => 'Search users by location',
    '5' => 'Exit'
  }.freeze

  # Method to display the menu options.
  def display
    # Iterate through each option and display it with its corresponding number.
    OPTIONS.each { |key, value| puts "#{key}. #{value}" }
  end
end

# Define a DataProcessor class responsible for reading and loading data from files.
class DataProcessor
  # Attributes to store dictionaries of posts and users.
  attr_reader :post_dict, :user_dict

  # Initialize empty dictionaries for posts and users.
  def initialize
    @post_dict = {}
    @user_dict = {}
  end

  # Method to read data from a file and populate the respective dictionary.
  def read_file(file_path, data_type)
    # Return false if the file does not exist.
    return false unless File.exist?(file_path)

    # Read each line of the file, split it, and assign values to the respective dictionary based on data_type.
    File.foreach(file_path) do |line|
      breakdown = line.chomp.split(';')
      id = breakdown.shift
      if data_type == 'Post'
        @post_dict[id] = breakdown
      elsif data_type == 'User'
        @user_dict[id] = breakdown
      end
    end
    true
  rescue Errno::ENOENT
    # Handle file not found error.
    puts "#{file_path} not found."
    false
  end

  # Method to load data from predefined file paths for posts and users.
  def load_data
    load_input_data('post-info.txt', 'Post')
    load_input_data('user-info.txt', 'User')
  end

  private

  # Method to prompt the user for file paths and load the data into the respective dictionary.
  def load_input_data(file_path, data_type)
    loop do
      puts "Enter #{data_type} file path (or type 'exit' to cancel): "
      input_path = gets.chomp
      return if input_path.downcase == 'exit'

      if read_file(input_path, data_type)
        puts "#{data_type} info loaded successfully."
        break
      end
    end
  end
end

# Define a class to check the visibility of posts based on user input.
class PostVisibilityChecker
  # Initialize with dictionaries of posts and users.
  def initialize(post_dict, user_dict)
    @post_dict = post_dict
    @user_dict = user_dict
  end

  # Method to check the visibility of a post.
  def check_visibility
    # Check if post or user dictionaries are empty.
    return puts 'Files not found. Please load input data first.' if @post_dict.empty? || @user_dict.empty?

    # Prompt user for post ID.
    puts 'Enter post ID: '
    post_id = gets.chomp

    # Check if the post ID exists in the post dictionary.
    unless @post_dict.key?(post_id)
      puts "Post with ID #{post_id} not found."
      return
    end

    # Prompt user for username.
    puts 'Enter username: '
    username = gets.chomp

    # Retrieve post and user details.
    post = @post_dict[post_id]
    user = @user_dict[post[0]]

    # Check if the post is public or the user has access based on post's visibility settings.
    if post[1] == 'public' || user[2].split(',').include?(username)
      puts 'Access granted'
    else
      puts 'Access denied'
    end
  end
end

# Define a class to search for users by location.
class UserLocationSearcher
  # Initialize with a dictionary of users.
  def initialize(user_dict)
    @user_dict = user_dict
  end

  # Method to search for users by location.
  def search_users_by_location
    # Prompt user for location input.
    puts 'Enter location: '
    location = gets.chomp

    # Select users from the user dictionary based on location.
    users = @user_dict.select { |_, details| details[1] == location }

    # Display results based on whether users are found or not.
    if users.empty?
      puts "No users found in #{location}."
    else
      users.keys.each { |user_id| puts user_id }
    end
  end
end

# Main function to execute the program.
def main
  # Create a DataProcessor instance.
  data_processor = DataProcessor.new
  # Load data from predefined file paths.
  data_processor.load_data

  # Create a Menu instance.
  menu = Menu.new
  # Display the menu options in a loop until the user chooses to exit.
  loop do
    menu.display
    puts 'Enter number for option: '
    choice = gets.chomp

    # Execute actions based on user's choice.
    case choice
    when '1'
      data_processor.load_data
    when '2'
      post_checker = PostVisibilityChecker.new(data_processor.post_dict, data_processor.user_dict)
      post_checker.check_visibility
    when '3'
      puts 'Enter username: '
      username = gets.chomp
      retrieve_posts(data_processor.post_dict, data_processor.user_dict, username)
    when '4'
      user_searcher = UserLocationSearcher.new(data_processor.user_dict)
      user_searcher.search_users_by_location
    when '5'
      puts 'Exiting program'
      break
    else
      puts 'Invalid option'
    end
  end
end

# Method to retrieve posts for a specific user based on visibility settings.
def retrieve_posts(post_dict, user_dict, username)
  # Select posts based on user's visibility rights.
  posts = post_dict.select do |post_id, details|
    details[1] == 'public' || user_dict[details[0]][2].split(',').include?(username)
  end

  # Display posts found or a message if no posts are found.
  if posts.empty?
    puts "No posts found for user #{username}."
  else
    posts.keys.each { |post_id| puts post_id }
  end
end

# Call the main function to start the program.
main

