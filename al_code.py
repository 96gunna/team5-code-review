# Function to output menu options
def load_menu():
    print("1. Load input data")
    print("2. Check visibility")
    print("3. Retrieve posts")
    print("4. Search users by location")
    print("5. Exit")


# Global dictionaries to hold information from the files
post_dict = {}
user_dict = {}


# User inputs file paths for post-info.txt and user-info.txt
# Information from the files are stored in post_dict and user_dict global variables
def read_files():
    global post_dict, user_dict
    post_info = None
    user_info = None
    post_info_path = input("Enter post-info file path: ")
    # Keep prompting the user for input until a file is found
    while not post_info:
        try:
            post_info = open(post_info_path, "r")
        except FileNotFoundError:
            print("post-info.txt not found.")
            post_info_path = input("Enter post-info file path: ")
        else:
            # Process each line in the file if successfully opened
            for line in post_info:
                breakdown = line.split(";")
                post_dict[breakdown[0]] = {"user": breakdown[1], "visibility": breakdown[2]}
            post_info.close()
    user_info_path = input("Enter user-info file path: ")
    # Keep prompting again this time for user-info
    while not user_info:
        try:
            user_info = open(user_info_path, "r")
        except FileNotFoundError:
            print("user-info.txt not found.")
            user_info_path = input("Enter user-info file path: ")
        else:
            for line in user_info:
                breakdown = line.split(";")
                user_dict[breakdown[0]] = {"name": breakdown[1],
                                           "location": breakdown[2],
                                           "friends": breakdown[3][1:-2].split(",")}


# Check if a user can view a specific post
def check_visibility():
    global post_dict, user_dict
    if post_dict and user_dict:
        post_id = input("Enter post ID: ")
        # End if the post_id doesn't exist
        if post_id not in post_dict:
            print(f'Post with ID {post_id} not found.')
            return
        username = input("Enter username: ")
        # Check if the post visibility is set to public
        if post_dict[post_id]["visibility"] == "public":
            print("Access granted")
        # Check if the username is not in the post author's friend list
        elif username not in user_dict[post_dict[post_id]["user"]]["friends"]:
            print("Access denied")
        else:
            print("Access granted")
    else:
        print("Files not found. Please load input data first.")


# Search for posts that an inputted username can view
def search_posts():
    global post_dict, user_dict
    username = input("Enter username: ")
    posts = []
    for post in post_dict:
        # Check if post has public visibility
        if post_dict[post]["visibility"] == "public":
            posts.append(post)
        # Check if the user is in the post author's friend list
        elif username in user_dict[post_dict[post]["user"]]["friends"]:
            posts.append(post)
    for post in posts:
        print(post)


# Searches through user_dict for users with matching locations and outputs their usernames
def user_by_location():
    global user_dict
    location = input("Enter location: ")
    users = []
    # Sequential search through user_dict looking for users with a matching location
    for user in user_dict:
        if user_dict[user]["location"] == location:
            users.append(user)
    if len(users) == 0:
        print("No users found.")
    else:
        for user in users:
            print(user)


def make_selections():
    while True:
        load_menu()
        choice = input("Enter number for option: ")
        if choice == "1":
            read_files()
        elif choice == "2":
            check_visibility()
        elif choice == "3":
            search_posts()
        elif choice == "4":
            user_by_location()
        elif choice == "5":
            print("Exiting program")
            break
        else:
            print("Invalid option")


make_selections()
