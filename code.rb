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

# User inputs file paths for post-info.txt and user-info.txt
# Information from the files are stored in $post_dict and $user_dict global variables
def read_files
  post_info = nil
  user_info = nil

  puts "Enter post-info file path: "
  post_info_path = gets.chomp

  # Keep prompting the user for input until a file is found
  until post_info
    begin
      post_info = File.open(post_info_path, "r")
    rescue Errno::ENOENT
      puts "post-info.txt not found."
      print "Enter post-info file path: "
      post_info_path = gets.chomp
    else
      # Process each line in the file if successfully opened
      post_info.each_line do |line|
        breakdown = line.split(";")
        $post_dict[breakdown[0]] = { "user" => breakdown[1], "visibility" => breakdown[2] }
      end
      post_info.close
    end
  end

  puts "Enter user-info file path: "
  user_info_path = gets.chomp

  # Keep prompting again this time for user-info
  until user_info
    begin
      user_info = File.open(user_info_path, "r")
    rescue Errno::ENOENT
      puts "user-info.txt not found."
      print "Enter user-info file path: "
      user_info_path = gets.chomp
    else
      user_info.each_line do |line|
        breakdown = line.split(";")
        $user_dict[breakdown[0]] = {
          "name" => breakdown[1],
          "location" => breakdown[2],
          "friends" => breakdown[3][1..-2].split(",")
        }
      end
      user_info.close
    end
  end
end

# Check if a user can view a specific post
def check_visibility
  if !$post_dict.empty? && !$user_dict.empty?
    puts "Enter post ID: "
    post_id = gets.chomp

    # End if the post_id doesn't exist
    unless $post_dict.key?(post_id)
      puts "Post with ID #{post_id} not found."
      return
    end

    puts "Enter username: "
    username = gets.chomp

    # Check post visibility and user's access
    if $post_dict[post_id]["visibility"] == "public"
      puts "Access granted"
    elsif !$user_dict[$post_dict[post_id]["user"]]["friends"].include?(username)
      puts "Access denied"
    else
      puts "Access granted"
    end
  else
    puts "Files not found. Please load input data first."
  end
end

# Search for posts that an inputted username can view
def search_posts
  puts "Enter username: "
  username = gets.chomp
  posts = []

  $post_dict.each do |post, details|
    if details["visibility"] == "public" || $user_dict[details["user"]]["friends"].include?(username)
      posts << post
    end
  end

  posts.each { |post| puts post }
end

# Searches through $user_dict for users with matching locations and outputs their usernames
def user_by_location
  puts "Enter location: "
  location = gets.chomp
  users = []

  $user_dict.each do |user, details|
    if details["location"] == location
      users << user
    end
  end

  if users.empty?
    puts "No users found."
  else
    users.each { |user| puts user }
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
      read_files
    when "2"
      check_visibility
    when "3"
      search_posts
    when "4"
      user_by_location
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
