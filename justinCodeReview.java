import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

public class justinCodeReview {

    // Function to output menu options
    public static void loadMenu() {
        System.out.println("1. Load input data");
        System.out.println("2. Check visibility");
        System.out.println("3. Retrieve posts");
        System.out.println("4. Search users by location");
        System.out.println("5. Exit");
    }

    // Global maps to hold information from the files
    public static Map<String, Map<String, String>> postDictionary = new HashMap<>();
    public static Map<String, Map<String, String>> userDictionary = new HashMap<>();

    // User inputs file paths for post-info.txt and user-info.txt
    // Information from the files are stored in postDict and userDict global variables
    public static void readFiles() {
        Scanner scanner = new Scanner(System.in);
        BufferedReader postInfo = null;
        BufferedReader userInfo = null;
        try {
            System.out.print("Enter post-info file path: ");
            String postInfoPath = scanner.nextLine();
            postInfo = new BufferedReader(new FileReader(postInfoPath));
            String line;
            while ((line = postInfo.readLine()) != null) {
                String[] breakdown = line.split(";");
                Map<String, String> postInfoMap = new HashMap<>();
                postInfoMap.put("user", breakdown[1]);
                postInfoMap.put("visibility", breakdown[2]);
                postDictionary.put(breakdown[0], postInfoMap);
            }
            postInfo.close();

            System.out.print("Enter user-info file path: ");
            String userInfoPath = scanner.nextLine();
            userInfo = new BufferedReader(new FileReader(userInfoPath));
            while ((line = userInfo.readLine()) != null) {
                String[] breakdown = line.split(";");
                Map<String, String> userInfoMap = new HashMap<>();
                userInfoMap.put("name", breakdown[1]);
                userInfoMap.put("location", breakdown[2]);
                String[] friends = breakdown[3].substring(1, breakdown[3].length() - 1).split(",");
                userInfoMap.put("friends", friends.toString());
                userDictionary.put(breakdown[0], userInfoMap);
            }
            userInfo.close();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (postInfo != null) postInfo.close();
                if (userInfo != null) userInfo.close();
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
    }

    // Check if a user can view a specific post
    public static void checkVisibility() {
        Scanner scanner = new Scanner(System.in);
        if (!postDictionary.isEmpty() && !userDictionary.isEmpty()) {
            System.out.print("Enter post ID: ");
            String postId = scanner.nextLine();
            if (!postDictionary.containsKey(postId)) {
                System.out.println("Post with ID " + postId + " not found.");
                return;
            }
            System.out.print("Enter username: ");
            String username = scanner.nextLine();
            if ("public".equals(postDictionary.get(postId).get("visibility")) ||
                    userDictionary.get(postDictionary.get(postId).get("user")).get("friends").contains(username)) {
                System.out.println("Access granted");
            } else {
                System.out.println("Access denied");
            }
        } else {
            System.out.println("Files not found. Please load input data first.");
        }
    }

    // Search for posts that an inputted username can view
    public static void searchPosts() {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter username: ");
        String username = scanner.nextLine();
        for (Map.Entry<String, Map<String, String>> entry : postDictionary.entrySet()) {
            String postId = entry.getKey();
            String visibility = entry.getValue().get("visibility");
            String postUser = entry.getValue().get("user");
            if ("public".equals(visibility) || userDictionary.get(postUser).get("friends").contains(username)) {
                System.out.println(postId);
            }
        }
    }

    // Searches through userDict for users with matching locations and outputs their usernames
    public static void userByLocation() {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter location: ");
        String location = scanner.nextLine();
        boolean found = false;
        for (Map.Entry<String, Map<String, String>> entry : userDictionary.entrySet()) {
            String userId = entry.getKey();
            String userLocation = entry.getValue().get("location");
            if (userLocation.equals(location)) {
                System.out.println(userId);
                found = true;
            }
        }
        if (!found) {
            System.out.println("No users found.");
        }
    }

    public static void makeSelections() {
        Scanner scanner = new Scanner(System.in);
        while (true) {
            loadMenu();
            System.out.print("Enter number for option: ");
            String choice = scanner.nextLine();
            switch (choice) {
                case "1":
                    readFiles();
                    break;
                case "2":
                    checkVisibility();
                    break;
                case "3":
                    searchPosts();
                    break;
                case "4":
                    userByLocation();
                    break;
                case "5":
                    System.out.println("Exiting program");
                    return;
                default:
                    System.out.println("Invalid option");
            }
        }
    }

    public static void main(String[] args) {
        makeSelections();
    }
}