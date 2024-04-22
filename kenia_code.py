# Dictionary to store post information
post_info = {}
# Dictionary to store user information
user_info = {}

# Function to read input files and populate our post & info dictionaries
def read_input_files():
    global post_info, user_info
    post_info_file = None
    user_info_file = None

    # Loop to input and read post_info.txt file
    while not post_info_file:
        post_info_path = input("Enter the file path & file for post-info.txt: ")
        try:
            with open(post_info_path, "r") as post_info_file:
                 # Reading each line to extract post information
                for line in post_info_file:
                    post_id, user, visibility = line.strip().split(";")
                    post_info[post_id] = {"user": user, "visibility": visibility}
        except FileNotFoundError:
            print("file not found.")
    post_info_file.close()

    # Loop to input and read user_info.txt file
    while not user_info_file:
        user_info_path = input("Enter the file path & file for user-info.txt: ")
        try:
            with open(user_info_path, "r") as user_info_file:
                 # Reading each line to extract user information
                for line in user_info_file:
                    user_id, name, location, friends = line.strip().split(";")
                    user_info[user_id] = {"name": name, "location": location, "friends": friends.split(",")}
        except FileNotFoundError:
            print("file not found.")
    user_info_file.close()

# Function to search for accessible posts based on user's friends and post visibility
def search_accessible_posts():
    if not post_info or not user_info:
        print("Files not found.")
        return

    username = input("Enter username: ")
    # searching accessible posts for the given username
    accessible_posts = [post_id for post_id, post_info in post_info.items()
                        if post_info["visibility"] == "public" or username in user_info[post_info["user"]]["friends"]]
    for post_id in accessible_posts:
        # Printing accessible post IDs
        print(post_id)


# Function to check visibility of a specific post for a given user
def check_post_visibility():
    if not post_info or not user_info:
        print("Files not found.")
        return

    post_id = input("Enter post ID: ")
    if post_id not in post_info:
        print(f'Post with ID {post_id} not found.')
        return

    username = input("Enter username: ")
    # Checking if the post is accessible for input user
    if post_info[post_id]["visibility"] == "public" or username in user_info[post_info[post_id]["user"]]["friends"]:
        print("Access granted")
    else:
        print("Access denied")


# Function to search users based on location
def search_users_by_location():
    location = input("Enter location: ")
    # Finding users with the given location
    matching_users = [user_id for user_id, user_info in user_info.items() if user_info["location"] == location]
    # Printing matching user IDs
    if matching_users:
        for user_id in matching_users:
            print(user_id)
    else:
        print("No users found.")


# Function to run entered selection
def execute_menu_selection():
    while True:
        menu_options()
        choice = input("Please select 1-5: ")
        if choice == "1":
            read_input_files()
        elif choice == "2":
            check_post_visibility()
        elif choice == "3":
            search_accessible_posts()
        elif choice == "4":
            search_users_by_location()
        elif choice == "5":
            print("Exiting program")
            break
        else:
            print("Invalid option")


# Function to display the starting options
def menu_options():
    print("1. Load input data")
    print("2. Check visibility")
    print("3. Retrieve posts")
    print("4. Search users by location")
    print("5. Exit")


execute_menu_selection()
