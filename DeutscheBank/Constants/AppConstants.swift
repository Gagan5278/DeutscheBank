//
//  AppConstants.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import Foundation

enum AppConstants {
    static let commonPadingConstants: CGFloat = 10
}

extension AppConstants {
    enum APIRequest {
        static let baseURL = "https://jsonplaceholder.typicode.com/"  // Can be injected in PLIST or UserDefinedSetting as per envoirnment after having different target in the app e.g. DEV, STAGE, PROD
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
        static let navigationTitle = "My Posts"
        static let filterAllPostSegmentTitle = "All Posts"
        static let filterFavoritePostSegmentTitle = "Favorite Posts"
        static let commonAlertTitle = "Message"
        static let emptyPostAlertMessage = "No post found for entered user id. Please enter a valid user id"
        static let alertGoBackButtonTitle = "Go Back"
        static let errorPostAlertMessage = "An error occured while loading post from server. Please check your internet and try again"
    }
}

extension AppConstants {
    enum CommentListScreenConstants {
        static let navigationTitle = "Comments"
        static let emptyPostAlertMessage = "No comment found for selected post. Please try another post."
        static let alertButtonTitle = "OK"
        static let alertTitle = "Message"
        static let errorCommentAlertMessage = "An error occured while loading comment from server for selected post. Please check your internet and try again"
        static let commentSetionHeaderTitle = "Post Comments"
    }
}
