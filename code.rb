# Function to output menu options
def load_menu
  puts "1. Load input data"
  puts "2. Check visibility"
  puts "3. Retrieve posts"
  puts "4. Search users by location"
  puts "5. Exit"
end

# Global hashes to hold information from the files
$post_dict = {}
$user_dict = {}

# Function to read and process post-info.txt or user-info.txt
def read_file(file_path, dict)
  begin
    File.foreach(file_path) do |line|
      breakdown = line.chomp.split(";")
      dict[breakdown[0]] = breakdown[1..-1]
    end
  rescue Errno::ENOENT
    puts "#{file_path} not found."
    return false
  end
  true
end

# Function to load input data
def load_input_data
  loop do
    puts "Enter post-info file path (or type 'exit' to cancel): "
    post_info_path = gets.chomp
    break if post_info_path.downcase == 'exit'

    if read_file(post_info_path, $post_dict)
      puts "Post info loaded successfully."
      break
    end
  end

  loop do
    puts "Enter user-info file path (or type 'exit' to cancel): "
    user_info_path = gets.chomp
    break if user_info_path.downcase == 'exit'

    if read_file(user_info_path, $user_dict)
      puts "User info loaded successfully."
      break
    end
  end
end

# Function to check post visibility
def check_visibility
  if $post_dict.empty? || $user_dict.empty?
    puts "Files not found. Please load input data first."
    return
  end

  puts "Enter post ID: "
  post_id = gets.chomp

  unless $post_dict.key?(post_id)
    puts "Post with ID #{post_id} not found."
    return
  end

  puts "Enter username: "
  username = gets.chomp

  post = $post_dict[post_id]
  user = $user_dict[post[0]]

  if post[1] == "public" || user[2].split(",").include?(username)
    puts "Access granted"
  else
    puts "Access denied"
  end
end

# Function to retrieve posts based on user visibility
def retrieve_posts(username)
  posts = $post_dict.select do |post_id, details|
    details[1] == "public" || $user_dict[details[0]][2].split(",").include?(username)
  end

  posts.keys.each { |post_id| puts post_id }
end

# Function to search users by location
def search_users_by_location(location)
  users = $user_dict.select { |user_id, details| details[1] == location }

  if users.empty?
    puts "No users found in #{location}."
  else
    users.keys.each { |user_id| puts user_id }
  end
end

# Main function to handle user selections
def make_selections
  loop do
    load_menu
    puts "Enter number for option: "
    choice = gets.chomp

    case choice
    when "1"
      load_input_data
    when "2"
      check_visibility
    when "3"
      puts "Enter username: "
      username = gets.chomp
      retrieve_posts(username)
    when "4"
      puts "Enter location: "
      location = gets.chomp
      search_users_by_location(location)
    when "5"
      puts "Exiting program"
      break
    else
      puts "Invalid option"
    end
  end
end

# Call the main function to start the program
make_selections

