//
//  WeiboAPI.swift
//  Flood
//
//  Created by byyyf on 2/3/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import Foundation
import Alamofire

public enum WeiboURL: String, URLStringConvertible {
    /*** 读取接口 ***/
     
     // 获取当前登录用户及其所关注用户的最新微博的ID
    case FriendsTimeline = "friends_timeline"
    // 获取用户发布的微博
    case UserTimeline = "user_timeline"
    
    case RepostTimeline = "repost_timeline"
    
    /*** 写入接口 ***/
     
     // 发布一条微博信息
    case UpdateText = "update"
    // 上传图片并发布一条微博
    case UpdateTextWithPicture = "upload"
    
    case RepostWeibo = "repost"
    
    public var URLString: String {
        return "https://api.weibo.com/2/statuses/\(rawValue).json"
    }
}

public enum CommentURL: String, URLStringConvertible {
    /*** 读取接口 ***/
     
     // 获取某条微博的评论列表
    case CommentsForWeibo = "show"
    // 我发出的评论列表
    case Sended = "by_me"
    // 我收到的评论列表
    case Recieved = "to_me"
    // 获取用户发送及收到的评论列表
    case Timeline = "timeline"
    // 获取@到我的评论
    case AtMe = "mentions"
    
    /*** 写入接口 ***/
     
     // 评论一条微博
    case CommentWeibo = "create"
    // 删除一条评论
    case DeleteComment = "destroy"
    // 回复一条评论
    case ReplyComment = "reply"
    
    public var URLString: String {
        return "https://api.weibo.com/2/comments/\(rawValue).json"
    }
}

public enum UserURL: String, URLStringConvertible {
    /*** 读取接口 ***/
     
     // 获取用户信息
    case UserInfo = "show"
    // 批量获取用户的粉丝数、关注数、微博数
    case UserCounts = "counts"
    
    public var URLString: String {
        return "https://api.weibo.com/2/users/\(rawValue).json"
    }
}

public enum FriendshipsURL: String, URLStringConvertible {
    /*** 读取接口 ***/
     
     // 获取我的关注人中关注了指定用户的人
    case PeoplesWhoFollowMeFollowTargetPeople = "friends_chain/followers"
    
    // 关注某用户
    case Follow = "create"
    // 取消关注某用户
    case unFollow = "destroy"
    
    // 获取用户的关注列表
    case FriendList = "friends"
    // 获取用户粉丝列表
    case FollowerList = "followers"
    // 获取用户优质粉丝列表
    case ActiveFollowerList = "followers/active"
    
    public var URLString: String {
        return "https://api.weibo.com/2/friendships/\(rawValue).json"
    }
}

public enum FavoritesURL: String, URLStringConvertible {
    /*** 读取接口 ***/
    
    case favorites = "favorites"
    
    /*** 写入接口 ***/
    
    case add = "create"
    case delete  = "destroy"
    case deleteBatch = "destroy_batch"
    
    public var URLString: String {
        return "https://api.weibo.com/2/favorites/\(rawValue).json"
    }
}

public enum RemindURL: String, URLStringConvertible {
    /*** 读取接口 ***/
    
    case unreadCount = "unread_count"
    
    case clearCount = "set_count"
    
    public var URLString: String {
        return "https://api.weibo.com/2/remind/\(rawValue).json"
    }
}

public enum PrivateURL: String, URLStringConvertible {
    // 热门评论
    case HotComment = "http://m.weibo.cn/single/rcList?format=cards&type=comment&hot=0"
    
    case SearchUser = "http://m.weibo.cn/page/pageJson?containerid=&containerid=100103type%3D3%26q%3Deva&type=user&v_p=11&ext=&fid=100103type%3D3%26q%3Deva&uicode=10000011"
    
    case SearchWeibo = "http://m.weibo.cn/page/pageJson?containerid=&containerid=100103type%3d1%26q%3deva&luicode=20000174&lfid=100103type%3d25&v_p=11&ext=&fid=100103type%3d1%26q%3deva&uicode=10000011"
    
    public var URLString: String {
        return rawValue
    }
}

