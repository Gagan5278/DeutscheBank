//
//  AppConstants.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import Foundation

enum AppConstants {
    static let commonPaadingConstants: CGFloat = 10
}

extension AppConstants {
    enum APIRequest {
        static let baseURL = "https://jsonplaceholder.typicode.com/"
    }
    enum APIError {
        static let somethingWentWrongResponse = "An error occured while calling service."
        static let serilizationFailedResponse = "JSONSerialization failed."
        static let badURLResponse = "Malformed URL sent to session."
        static let conversionFailedToHTTPURLResponse = "Type casting failed"
    }
}

extension AppConstants {
    enum LoginScreenConstants {
        static let loginButtonTitle = "Login"
        static let textFieldToolbarButtonTitle = "Done"
        static let textFieldPlaceHolder = "Please enter user id (1 to 10)"
        static let navigationTitle = "User Login"
    }
}

extension AppConstants {
    enum PostListScreenConstants {
        static let navigationTitle = "Post"
        static let filterAllPostSegmentTitle = "All Posts"
        static let filterFavoritePostSegmentTitle = "Favorite Posts"
        static let emptyPostAlertTitle = "Message"
        static let emptyPostAlertMessage = "No post found for entered user id. Please enter a valid user id"
        static let emptyPostButtonTitle = "Go Back"
    }
}
