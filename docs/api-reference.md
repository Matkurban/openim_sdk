# OpenIM SDK API 接口文档

> 基于 `openim-sdk-core` 项目自动生成  
> Protocol 版本: `v0.0.73-alpha.12`  
> 所有接口均为 **POST** 请求，Content-Type: `application/json`

## 通用请求格式

```
POST {API_BASE_URL}{endpoint}
Headers:
  Content-Type: application/json
  operationID: <唯一操作ID>
  token: <用户Token>
  Accept-Encoding: gzip
Timeout: 10s
```

## 通用响应格式

```json
{
  "errCode": 0,
  "errMsg": "",
  "errDlt": "",
  "data": { ... }
}
```

> 以下文档中的 **请求参数** 和 **响应参数** 均指 `data` 字段内部的内容。

---

## 目录

- [1. 认证模块 (Auth)](#1-认证模块-auth)
- [2. 用户模块 (User)](#2-用户模块-user)
- [3. 好友/关系模块 (Relation)](#3-好友关系模块-relation)
- [4. 消息模块 (Message)](#4-消息模块-message)
- [5. 群组模块 (Group)](#5-群组模块-group)
- [6. 会话模块 (Conversation)](#6-会话模块-conversation)
- [7. 第三方服务模块 (Third)](#7-第三方服务模块-third)
- [8. 对象存储模块 (Object Storage)](#8-对象存储模块-object-storage)
- [附录：公共数据结构](#附录公共数据结构)

---

## 1. 认证模块 (Auth)

### 1.1 获取管理员Token

`POST /auth/get_admin_token`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| secret | string | 是 | 管理员密钥 |
| userID | string | 是 | 管理员用户ID |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| token | string | 认证Token |
| expireTimeSeconds | int64 | Token过期时间(秒) |

**请求示例：**
```json
{
  "secret": "openIM123",
  "userID": "admin001"
}
```

---

### 1.2 获取用户Token

`POST /auth/get_user_token`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| platformID | int32 | 是 | 平台ID (1:iOS, 2:Android, 3:Windows, 4:macOS, 5:Web, 6:MiniWeb, 7:Linux, 8:APad, 9:iPad, 10:Admin) |
| userID | string | 是 | 用户ID |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| token | string | 认证Token |
| expireTimeSeconds | int64 | Token过期时间(秒) |

**请求示例：**
```json
{
  "platformID": 5,
  "userID": "user001"
}
```

---

### 1.3 解析Token

`POST /auth/parse_token`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| token | string | 是 | 待解析的Token |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| userID | string | 用户ID |
| platformID | int32 | 平台ID |
| expireTimeSeconds | int64 | Token过期时间(秒) |

**请求示例：**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIs..."
}
```

---

## 2. 用户模块 (User)

### 2.1 获取指定用户信息

`POST /user/get_users_info`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| userIDs | string[] | 是 | 用户ID列表 |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| usersInfo | [UserInfo](#userinfo)[] | 用户信息列表 |

**请求示例：**
```json
{
  "userIDs": ["user001", "user002"]
}
```

---

### 2.2 更新用户信息

`POST /user/update_user_info`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| userInfo | [UserInfo](#userinfo) | 是 | 用户信息对象 |

**响应参数：** 无

**请求示例：**
```json
{
  "userInfo": {
    "userID": "user001",
    "nickname": "新昵称",
    "faceURL": "https://example.com/avatar.png",
    "ex": ""
  }
}
```

---

### 2.3 更新用户信息(扩展)

`POST /user/update_user_info_ex`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| userInfo | [UserInfoWithEx](#userinfowithex) | 是 | 用户信息（可选字段更新） |

**响应参数：** 无

**请求示例：**
```json
{
  "userInfo": {
    "userID": "user001",
    "nickname": { "value": "新昵称" },
    "faceURL": { "value": "https://example.com/avatar.png" }
  }
}
```

---

### 2.4 用户注册

`POST /user/user_register`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| users | [UserInfo](#userinfo)[] | 是 | 待注册用户信息列表 |

**响应参数：** 无

**请求示例：**
```json
{
  "users": [
    {
      "userID": "user001",
      "nickname": "用户1",
      "faceURL": "https://example.com/avatar.png"
    }
  ]
}
```

---

### 2.5 获取用户客户端配置

`POST /user/get_user_client_config`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| userID | string | 是 | 用户ID |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| configs | map\<string, string\> | 配置键值对 |

**请求示例：**
```json
{
  "userID": "user001"
}
```

---

## 3. 好友/关系模块 (Relation)

### 3.1 申请添加好友

`POST /friend/add_friend`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| fromUserID | string | 是 | 申请人用户ID |
| toUserID | string | 是 | 目标用户ID |
| reqMsg | string | 否 | 申请消息 |
| ex | string | 否 | 扩展字段 |

**响应参数：** 无

**请求示例：**
```json
{
  "fromUserID": "user001",
  "toUserID": "user002",
  "reqMsg": "你好，我想加你为好友"
}
```

---

### 3.2 删除好友

`POST /friend/delete_friend`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| ownerUserID | string | 是 | 操作者用户ID |
| friendUserID | string | 是 | 被删除好友的用户ID |

**响应参数：** 无

**请求示例：**
```json
{
  "ownerUserID": "user001",
  "friendUserID": "user002"
}
```

---

### 3.3 获取收到的好友申请列表

`POST /friend/get_friend_apply_list`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| userID | string | 是 | 用户ID |
| pagination | [RequestPagination](#requestpagination) | 否 | 分页参数 |
| handleResults | int32[] | 否 | 处理结果过滤 |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| FriendRequests | [FriendRequest](#friendrequest)[] | 好友申请列表 |
| total | int32 | 总数 |

**请求示例：**
```json
{
  "userID": "user001",
  "pagination": { "pageNumber": 1, "showNumber": 20 }
}
```

---

### 3.4 获取发出的好友申请列表

`POST /friend/get_self_friend_apply_list`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| userID | string | 是 | 用户ID |
| pagination | [RequestPagination](#requestpagination) | 否 | 分页参数 |
| handleResults | int32[] | 否 | 处理结果过滤 |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| friendRequests | [FriendRequest](#friendrequest)[] | 好友申请列表 |
| total | int32 | 总数 |

---

### 3.5 获取未处理好友申请数量

`POST /friend/get_self_unhandled_apply_count`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| userID | string | 是 | 用户ID |
| time | int64 | 否 | 时间戳过滤 |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| count | int64 | 未处理数量 |

---

### 3.6 导入好友关系

`POST /friend/import_friend`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| ownerUserID | string | 是 | 用户ID |
| friendUserIDs | string[] | 是 | 好友用户ID列表 |

**响应参数：** 无

---

### 3.7 获取指定好友申请

`POST /friend/get_designated_friend_apply`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| fromUserID | string | 是 | 申请人ID |
| toUserID | string | 是 | 接收人ID |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| friendRequests | [FriendRequest](#friendrequest)[] | 好友申请列表 |

---

### 3.8 获取好友列表(分页)

`POST /friend/get_friend_list`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| pagination | [RequestPagination](#requestpagination) | 否 | 分页参数 |
| userID | string | 是 | 用户ID |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| friendsInfo | [FriendInfo](#friendinfo)[] | 好友信息列表 |
| total | int32 | 总数 |

---

### 3.9 获取指定好友信息

`POST /friend/get_designated_friends`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| ownerUserID | string | 是 | 用户ID |
| friendUserIDs | string[] | 是 | 好友用户ID列表 |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| friendsInfo | [FriendInfo](#friendinfo)[] | 好友信息列表 |

---

### 3.10 处理好友申请

`POST /friend/add_friend_response`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| fromUserID | string | 是 | 申请发起人ID |
| toUserID | string | 是 | 申请接收人ID |
| handleResult | int32 | 是 | 处理结果（1:同意, -1:拒绝） |
| handleMsg | string | 否 | 处理消息 |

**响应参数：** 无

**请求示例：**
```json
{
  "fromUserID": "user002",
  "toUserID": "user001",
  "handleResult": 1,
  "handleMsg": "同意"
}
```

---

### 3.11 更新好友信息

`POST /friend/update_friends`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| ownerUserID | string | 是 | 用户ID |
| friendUserIDs | string[] | 是 | 好友用户ID列表 |
| isPinned | BoolValue | 否 | 是否置顶 |
| remark | StringValue | 否 | 备注 |
| ex | StringValue | 否 | 扩展字段 |

**响应参数：** 无

---

### 3.12 增量获取好友列表

`POST /friend/get_incremental_friends`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| userID | string | 是 | 用户ID |
| versionID | string | 是 | 版本ID |
| version | uint64 | 是 | 版本号 |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| version | uint64 | 最新版本号 |
| versionID | string | 版本ID |
| full | bool | 是否全量 |
| delete | string[] | 删除的好友ID列表 |
| insert | [FriendInfo](#friendinfo)[] | 新增好友 |
| update | [FriendInfo](#friendinfo)[] | 更新好友 |
| sortVersion | uint64 | 排序版本号 |

---

### 3.13 获取全量好友ID列表

`POST /friend/get_full_friend_user_ids`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| idHash | uint64 | 是 | ID哈希值 |
| userID | string | 是 | 用户ID |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| version | uint64 | 版本号 |
| versionID | string | 版本ID |
| equal | bool | 是否相同(无变化) |
| userIDs | string[] | 用户ID列表 |

---

### 3.14 添加黑名单

`POST /friend/add_black`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| ownerUserID | string | 是 | 操作者用户ID |
| blackUserID | string | 是 | 被拉黑用户ID |
| ex | string | 否 | 扩展字段 |

**响应参数：** 无

---

### 3.15 移除黑名单

`POST /friend/remove_black`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| ownerUserID | string | 是 | 操作者用户ID |
| blackUserID | string | 是 | 被移除黑名单用户ID |

**响应参数：** 无

---

### 3.16 获取黑名单列表

`POST /friend/get_black_list`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| userID | string | 是 | 用户ID |
| pagination | [RequestPagination](#requestpagination) | 否 | 分页参数 |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| blacks | [BlackInfo](#blackinfo)[] | 黑名单列表 |
| total | int32 | 总数 |

---

## 4. 消息模块 (Message)

### 4.1 发送消息

`POST /msg/send_msg`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| msgData | [MsgData](#msgdata) | 是 | 消息体 |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| serverMsgID | string | 服务端消息ID |
| clientMsgID | string | 客户端消息ID |
| sendTime | int64 | 发送时间 |
| modify | [MsgData](#msgdata) | 修改后的消息体 |

**请求示例：**
```json
{
  "msgData": {
    "sendID": "user001",
    "recvID": "user002",
    "sessionType": 1,
    "contentType": 101,
    "content": "aGVsbG8=",
    "senderNickname": "用户1",
    "senderFaceURL": "https://example.com/avatar.png"
  }
}
```

---

### 4.2 撤回消息

`POST /msg/revoke_msg`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| conversationID | string | 是 | 会话ID |
| seq | int64 | 是 | 消息序列号 |
| userID | string | 是 | 操作者用户ID |

**响应参数：** 无

**请求示例：**
```json
{
  "conversationID": "si_user001_user002",
  "seq": 100,
  "userID": "user001"
}
```

---

### 4.3 标记消息已读

`POST /msg/mark_msgs_as_read`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| conversationID | string | 是 | 会话ID |
| seqs | int64[] | 是 | 消息序列号列表 |
| userID | string | 是 | 用户ID |

**响应参数：** 无

---

### 4.4 标记会话已读

`POST /msg/mark_conversation_as_read`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| conversationID | string | 是 | 会话ID |
| userID | string | 是 | 用户ID |
| hasReadSeq | int64 | 是 | 已读到的序列号 |
| seqs | int64[] | 否 | 消息序列号列表 |

**响应参数：** 无

---

### 4.5 设置会话已读序列号

`POST /msg/set_conversation_has_read_seq`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| conversationID | string | 是 | 会话ID |
| userID | string | 是 | 用户ID |
| hasReadSeq | int64 | 是 | 已读序列号 |
| noNotification | bool | 否 | 是否不发通知 |

**响应参数：** 无

---

### 4.6 获取会话已读和最大序列号

`POST /msg/get_conversations_has_read_and_max_seq`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| userID | string | 是 | 用户ID |
| conversationIDs | string[] | 是 | 会话ID列表 |
| returnPinned | bool | 否 | 是否返回置顶会话 |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| seqs | map\<string, Seqs\> | 会话序列号映射 |
| pinnedConversationIDs | string[] | 置顶会话ID列表 |

其中 Seqs 结构：

| 字段 | 类型 | 说明 |
|------|------|------|
| maxSeq | int64 | 最大序列号 |
| hasReadSeq | int64 | 已读序列号 |
| maxSeqTime | int64 | 最大序列号时间 |

---

### 4.7 清空指定会话消息

`POST /msg/clear_conversation_msg`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| conversationIDs | string[] | 是 | 会话ID列表 |
| userID | string | 是 | 用户ID |
| deleteSyncOpt | object | 否 | 同步选项 |

deleteSyncOpt 结构：

| 字段 | 类型 | 说明 |
|------|------|------|
| IsSyncSelf | bool | 是否同步自己其他端 |
| IsSyncOther | bool | 是否同步对方 |

**响应参数：** 无

---

### 4.8 清空所有消息

`POST /msg/user_clear_all_msg`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| userID | string | 是 | 用户ID |
| deleteSyncOpt | object | 否 | 同步选项 |

**响应参数：** 无

---

### 4.9 删除指定消息

`POST /msg/delete_msgs`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| conversationID | string | 是 | 会话ID |
| seqs | int64[] | 是 | 消息序列号列表 |
| userID | string | 是 | 用户ID |
| deleteSyncOpt | object | 否 | 同步选项 |

**响应参数：** 无

---

### 4.10 获取服务器时间

`POST /msg/get_server_time`

**请求参数：** 无（空对象 `{}`）

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| serverTime | int64 | 服务器时间戳(毫秒) |

---

## 5. 群组模块 (Group)

### 5.1 创建群组

`POST /group/create_group`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| memberUserIDs | string[] | 否 | 初始成员ID列表 |
| groupInfo | [GroupInfo](#groupinfo) | 是 | 群组信息 |
| adminUserIDs | string[] | 否 | 管理员ID列表 |
| ownerUserID | string | 是 | 群主用户ID |
| sendMessage | bool | 否 | 是否发送通知消息 |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| groupInfo | [GroupInfo](#groupinfo) | 创建的群组信息 |

**请求示例：**
```json
{
  "memberUserIDs": ["user002", "user003"],
  "groupInfo": {
    "groupName": "测试群",
    "groupType": 2,
    "introduction": "这是一个测试群"
  },
  "ownerUserID": "user001"
}
```

---

### 5.2 设置群信息(扩展)

`POST /group/set_group_info_ex`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| groupID | string | 是 | 群组ID |
| groupName | StringValue | 否 | 群名称 |
| notification | StringValue | 否 | 群公告 |
| introduction | StringValue | 否 | 群简介 |
| faceURL | StringValue | 否 | 群头像URL |
| ex | StringValue | 否 | 扩展字段 |
| needVerification | Int32Value | 否 | 入群验证方式 |
| lookMemberInfo | Int32Value | 否 | 是否可查看成员信息 |
| applyMemberFriend | Int32Value | 否 | 是否可通过群加好友 |

**响应参数：** 无

---

### 5.3 申请加入群组

`POST /group/join_group`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| groupID | string | 是 | 群组ID |
| reqMessage | string | 否 | 申请消息 |
| joinSource | int32 | 否 | 加入来源 |
| inviterUserID | string | 否 | 邀请人ID |
| ex | string | 否 | 扩展字段 |

**响应参数：** 无

---

### 5.4 退出群组

`POST /group/quit_group`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| groupID | string | 是 | 群组ID |
| userID | string | 是 | 用户ID |

**响应参数：** 无

---

### 5.5 获取群组信息

`POST /group/get_groups_info`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| groupIDs | string[] | 是 | 群组ID列表 |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| groupInfos | [GroupInfo](#groupinfo)[] | 群组信息列表 |

---

### 5.6 获取群成员列表

`POST /group/get_group_member_list`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| pagination | [RequestPagination](#requestpagination) | 否 | 分页参数 |
| groupID | string | 是 | 群组ID |
| filter | int32 | 否 | 角色过滤 |
| keyword | string | 否 | 搜索关键词 |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| total | uint32 | 总数 |
| members | [GroupMemberFullInfo](#groupmemberfullinfo)[] | 群成员列表 |

---

### 5.7 获取指定群成员信息

`POST /group/get_group_members_info`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| groupID | string | 是 | 群组ID |
| userIDs | string[] | 是 | 成员用户ID列表 |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| members | [GroupMemberFullInfo](#groupmemberfullinfo)[] | 群成员信息列表 |

---

### 5.8 邀请用户入群

`POST /group/invite_user_to_group`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| groupID | string | 是 | 群组ID |
| reason | string | 否 | 邀请原因 |
| invitedUserIDs | string[] | 是 | 被邀请用户ID列表 |
| sendMessage | bool | 否 | 是否发送通知 |

**响应参数：** 无

---

### 5.9 获取已加入的群组列表

`POST /group/get_joined_group_list`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| pagination | [RequestPagination](#requestpagination) | 否 | 分页参数 |
| fromUserID | string | 是 | 用户ID |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| total | uint32 | 总数 |
| groups | [GroupInfo](#groupinfo)[] | 群组列表 |

---

### 5.10 踢出群成员

`POST /group/kick_group`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| groupID | string | 是 | 群组ID |
| kickedUserIDs | string[] | 是 | 被踢用户ID列表 |
| reason | string | 否 | 踢出原因 |
| sendMessage | bool | 否 | 是否发送通知 |

**响应参数：** 无

---

### 5.11 转让群主

`POST /group/transfer_group`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| groupID | string | 是 | 群组ID |
| oldOwnerUserID | string | 是 | 原群主用户ID |
| newOwnerUserID | string | 是 | 新群主用户ID |

**响应参数：** 无

---

### 5.12 获取收到的入群申请

`POST /group/get_recv_group_applicationList`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| pagination | [RequestPagination](#requestpagination) | 否 | 分页参数 |
| fromUserID | string | 是 | 群主/管理员用户ID |
| groupIDs | string[] | 否 | 群组ID过滤 |
| handleResults | int32[] | 否 | 处理结果过滤 |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| total | uint32 | 总数 |
| groupRequests | [GroupRequest](#grouprequest)[] | 入群申请列表 |

---

### 5.13 获取发出的入群申请

`POST /group/get_user_req_group_applicationList`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| pagination | [RequestPagination](#requestpagination) | 否 | 分页参数 |
| userID | string | 是 | 用户ID |
| groupIDs | string[] | 否 | 群组ID过滤 |
| handleResults | int32[] | 否 | 处理结果过滤 |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| total | uint32 | 总数 |
| groupRequests | [GroupRequest](#grouprequest)[] | 入群申请列表 |

---

### 5.14 获取未处理入群申请数量

`POST /group/get_group_application_unhandled_count`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| userID | string | 是 | 用户ID |
| time | int64 | 否 | 时间戳过滤 |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| count | int64 | 未处理数量 |

---

### 5.15 处理入群申请

`POST /group/group_application_response`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| groupID | string | 是 | 群组ID |
| fromUserID | string | 是 | 申请人ID |
| handledMsg | string | 否 | 处理消息 |
| handleResult | int32 | 是 | 处理结果（1:同意, -1:拒绝） |

**响应参数：** 无

---

### 5.16 解散群组

`POST /group/dismiss_group`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| groupID | string | 是 | 群组ID |
| deleteMember | bool | 否 | 是否删除成员 |
| sendMessage | bool | 否 | 是否发送通知 |

**响应参数：** 无

---

### 5.17 禁言群成员

`POST /group/mute_group_member`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| groupID | string | 是 | 群组ID |
| userID | string | 是 | 被禁言用户ID |
| mutedSeconds | uint32 | 是 | 禁言时长(秒) |

**响应参数：** 无

---

### 5.18 取消禁言群成员

`POST /group/cancel_mute_group_member`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| groupID | string | 是 | 群组ID |
| userID | string | 是 | 用户ID |

**响应参数：** 无

---

### 5.19 全员禁言

`POST /group/mute_group`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| groupID | string | 是 | 群组ID |

**响应参数：** 无

---

### 5.20 取消全员禁言

`POST /group/cancel_mute_group`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| groupID | string | 是 | 群组ID |

**响应参数：** 无

---

### 5.21 设置群成员信息

`POST /group/set_group_member_info`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| members | SetGroupMemberInfo[] | 是 | 群成员信息列表 |

SetGroupMemberInfo 结构：

| 字段 | 类型 | 说明 |
|------|------|------|
| groupID | string | 群组ID |
| userID | string | 用户ID |
| nickname | StringValue | 群昵称 |
| faceURL | StringValue | 群头像 |
| roleLevel | Int32Value | 角色等级 |
| ex | StringValue | 扩展字段 |

**响应参数：** 无

---

### 5.22 增量获取已加入群组

`POST /group/get_incremental_join_groups`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| userID | string | 是 | 用户ID |
| versionID | string | 是 | 版本ID |
| version | uint64 | 是 | 版本号 |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| version | uint64 | 最新版本号 |
| versionID | string | 版本ID |
| full | bool | 是否全量 |
| delete | string[] | 删除的群组ID |
| insert | [GroupInfo](#groupinfo)[] | 新增群组 |
| update | [GroupInfo](#groupinfo)[] | 更新群组 |
| sortVersion | uint64 | 排序版本号 |

---

### 5.23 批量增量获取群成员

`POST /group/get_incremental_group_members_batch`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| userID | string | 是 | 用户ID |
| reqList | object[] | 是 | 请求列表 |

reqList 中每个元素：

| 字段 | 类型 | 说明 |
|------|------|------|
| groupID | string | 群组ID |
| versionID | string | 版本ID |
| version | uint64 | 版本号 |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| respList | map\<string, object\> | 按群组ID的增量响应 |

---

### 5.24 获取全量已加入群组ID

`POST /group/get_full_join_group_ids`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| idHash | uint64 | 是 | ID哈希值 |
| userID | string | 是 | 用户ID |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| version | uint64 | 版本号 |
| versionID | string | 版本ID |
| equal | bool | 是否无变化 |
| groupIDs | string[] | 群组ID列表 |

---

### 5.25 获取全量群成员用户ID

`POST /group/get_full_group_member_user_ids`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| idHash | uint64 | 是 | ID哈希值 |
| groupID | string | 是 | 群组ID |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| version | uint64 | 版本号 |
| versionID | string | 版本ID |
| equal | bool | 是否无变化 |
| userIDs | string[] | 用户ID列表 |

---

## 6. 会话模块 (Conversation)

### 6.1 获取指定会话

`POST /conversation/get_conversations`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| ownerUserID | string | 是 | 用户ID |
| conversationIDs | string[] | 是 | 会话ID列表 |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| conversations | [Conversation](#conversation)[] | 会话列表 |

---

### 6.2 获取所有会话

`POST /conversation/get_all_conversations`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| ownerUserID | string | 是 | 用户ID |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| conversations | [Conversation](#conversation)[] | 会话列表 |

---

### 6.3 设置会话属性

`POST /conversation/set_conversations`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| userIDs | string[] | 是 | 用户ID列表 |
| conversation | [ConversationReq](#conversationreq) | 是 | 会话设置 |

**响应参数：** 无

---

### 6.4 增量获取会话

`POST /conversation/get_incremental_conversations`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| userID | string | 是 | 用户ID |
| versionID | string | 是 | 版本ID |
| version | uint64 | 是 | 版本号 |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| version | uint64 | 最新版本号 |
| versionID | string | 版本ID |
| full | bool | 是否全量 |
| delete | string[] | 删除的会话ID |
| insert | [Conversation](#conversation)[] | 新增会话 |
| update | [Conversation](#conversation)[] | 更新会话 |

---

### 6.5 获取全量会话ID

`POST /conversation/get_full_conversation_ids`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| idHash | uint64 | 是 | ID哈希值 |
| userID | string | 是 | 用户ID |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| version | uint64 | 版本号 |
| versionID | string | 版本ID |
| equal | bool | 是否无变化 |
| conversationIDs | string[] | 会话ID列表 |

---

### 6.6 获取用户会话(分页)

`POST /conversation/get_owner_conversation`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| userID | string | 是 | 用户ID |
| pagination | [RequestPagination](#requestpagination) | 是 | 分页参数 |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| total | int64 | 总数 |
| conversations | [Conversation](#conversation)[] | 会话列表 |

---

### 6.7 获取活跃会话

`POST /jssdk/get_active_conversations`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| ownerUserID | string | 是 | 用户ID |
| count | int64 | 否 | 获取数量 |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| unreadCount | int64 | 未读总数 |
| conversations | ConversationMsg[] | 会话消息列表 |

ConversationMsg 结构：

| 字段 | 类型 | 说明 |
|------|------|------|
| conversation | [Conversation](#conversation) | 会话信息 |
| lastMsg | [MsgData](#msgdata) | 最后一条消息 |
| user | [UserInfo](#userinfo) | 用户信息 |
| friend | FriendInfoOnly | 好友信息 |
| group | [GroupInfo](#groupinfo) | 群组信息 |
| maxSeq | int64 | 最大序列号 |
| readSeq | int64 | 已读序列号 |

---

## 7. 第三方服务模块 (Third)

### 7.1 更新FCM推送Token

`POST /third/fcm_update_token`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| platformID | int32 | 是 | 平台ID |
| fcmToken | string | 是 | FCM Token |
| account | string | 否 | 账号 |
| expireTime | int64 | 否 | 过期时间 |

**响应参数：** 无

---

### 7.2 设置App角标数

`POST /third/set_app_badge`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| userID | string | 是 | 用户ID |
| appUnreadCount | int32 | 是 | App未读数 |

**响应参数：** 无

---

### 7.3 上传日志

`POST /third/logs/upload`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| platform | int32 | 是 | 平台ID |
| fileURLs | FileURL[] | 是 | 文件URL列表 |
| appFramework | string | 否 | App框架 |
| version | string | 否 | App版本 |
| ex | string | 否 | 扩展字段 |

FileURL 结构：

| 字段 | 类型 | 说明 |
|------|------|------|
| filename | string | 文件名 |
| URL | string | 文件URL |

**响应参数：** 无

---

## 8. 对象存储模块 (Object Storage)

### 8.1 获取分片上传限制

`POST /object/part_limit`

**请求参数：** 无（空对象 `{}`）

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| minPartSize | int64 | 最小分片大小(字节) |
| maxPartSize | int64 | 最大分片大小(字节) |
| maxNumSize | int32 | 最大分片数 |

---

### 8.2 发起分片上传

`POST /object/initiate_multipart_upload`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| hash | string | 是 | 文件哈希 |
| size | int64 | 是 | 文件大小(字节) |
| partSize | int64 | 是 | 分片大小 |
| maxParts | int32 | 否 | 最大分片数 |
| cause | string | 否 | 上传原因 |
| name | string | 是 | 文件名 |
| contentType | string | 是 | MIME类型 |
| urlPrefix | string | 否 | URL前缀 |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| url | string | 如果文件已存在,直接返回URL |
| upload | UploadInfo | 上传信息 |

UploadInfo 结构：

| 字段 | 类型 | 说明 |
|------|------|------|
| uploadID | string | 上传ID |
| partSize | int64 | 分片大小 |
| sign | AuthSignParts | 签名信息 |
| expireTime | int64 | 过期时间 |

---

### 8.3 获取上传签名

`POST /object/auth_sign`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| uploadID | string | 是 | 上传ID |
| partNumbers | int32[] | 是 | 分片编号列表 |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| url | string | 上传URL |
| query | KeyValues[] | 查询参数 |
| header | KeyValues[] | 请求头 |
| parts | SignPart[] | 各分片签名信息 |

---

### 8.4 完成分片上传

`POST /object/complete_multipart_upload`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| uploadID | string | 是 | 上传ID |
| parts | string[] | 是 | 各分片标识 |
| name | string | 是 | 文件名 |
| contentType | string | 是 | MIME类型 |
| cause | string | 否 | 上传原因 |
| urlPrefix | string | 否 | URL前缀 |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| url | string | 文件访问URL |

---

### 8.5 获取文件访问URL

`POST /object/access_url`

**请求参数：**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| name | string | 是 | 文件名 |
| query | map\<string, string\> | 否 | 查询参数 |

**响应参数：**

| 字段 | 类型 | 说明 |
|------|------|------|
| url | string | 文件访问URL |
| expireTime | int64 | URL过期时间 |

---

## 附录：公共数据结构

### UserInfo

| 字段 | 类型 | 说明 |
|------|------|------|
| userID | string | 用户ID |
| nickname | string | 昵称 |
| faceURL | string | 头像URL |
| ex | string | 扩展字段 |
| createTime | int64 | 创建时间 |
| appMangerLevel | int32 | App管理等级 |
| globalRecvMsgOpt | int32 | 全局接收消息选项 |

### UserInfoWithEx

| 字段 | 类型 | 说明 |
|------|------|------|
| userID | string | 用户ID |
| nickname | StringValue | 昵称(可选更新) |
| faceURL | StringValue | 头像URL(可选更新) |
| ex | StringValue | 扩展字段(可选更新) |
| globalRecvMsgOpt | Int32Value | 全局接收消息选项(可选更新) |

### GroupInfo

| 字段 | 类型 | 说明 |
|------|------|------|
| groupID | string | 群组ID |
| groupName | string | 群名称 |
| notification | string | 群公告 |
| introduction | string | 群简介 |
| faceURL | string | 群头像URL |
| ownerUserID | string | 群主用户ID |
| createTime | int64 | 创建时间 |
| memberCount | uint32 | 成员数量 |
| ex | string | 扩展字段 |
| status | int32 | 群状态 |
| creatorUserID | string | 创建者用户ID |
| groupType | int32 | 群类型 |
| needVerification | int32 | 入群验证方式 |
| lookMemberInfo | int32 | 是否可查看成员信息 |
| applyMemberFriend | int32 | 是否可通过群加好友 |
| notificationUpdateTime | int64 | 公告更新时间 |
| notificationUserID | string | 公告更新用户ID |

### GroupMemberFullInfo

| 字段 | 类型 | 说明 |
|------|------|------|
| groupID | string | 群组ID |
| userID | string | 用户ID |
| roleLevel | int32 | 角色等级 (1:普通, 2:群主, 3:管理员) |
| joinTime | int64 | 加入时间 |
| nickname | string | 群昵称 |
| faceURL | string | 头像URL |
| appMangerLevel | int32 | App管理等级 |
| joinSource | int32 | 加入来源 |
| operatorUserID | string | 操作人ID |
| ex | string | 扩展字段 |
| muteEndTime | int64 | 禁言结束时间 |
| inviterUserID | string | 邀请人ID |

### Conversation

| 字段 | 类型 | 说明 |
|------|------|------|
| ownerUserID | string | 用户ID |
| conversationID | string | 会话ID |
| recvMsgOpt | int32 | 接收消息选项 (0:正常, 1:不提醒, 2:不接收) |
| conversationType | int32 | 会话类型 (1:单聊, 3:群聊, 4:通知) |
| userID | string | 对方用户ID(单聊) |
| groupID | string | 群组ID(群聊) |
| isPinned | bool | 是否置顶 |
| attachedInfo | string | 附加信息 |
| isPrivateChat | bool | 是否阅后即焚 |
| groupAtType | int32 | 群@类型 |
| ex | string | 扩展字段 |
| burnDuration | int32 | 焚烧时长(秒) |
| minSeq | int64 | 最小序列号 |
| maxSeq | int64 | 最大序列号 |
| msgDestructTime | int64 | 消息销毁时间 |
| latestMsgDestructTime | int64 | 最近消息销毁时间 |
| isMsgDestruct | bool | 是否开启消息销毁 |

### ConversationReq

| 字段 | 类型 | 说明 |
|------|------|------|
| conversationID | string | 会话ID |
| conversationType | int32 | 会话类型 |
| userID | string | 对方用户ID |
| groupID | string | 群组ID |
| recvMsgOpt | Int32Value | 接收消息选项 |
| isPinned | BoolValue | 是否置顶 |
| attachedInfo | StringValue | 附加信息 |
| isPrivateChat | BoolValue | 阅后即焚 |
| ex | StringValue | 扩展字段 |
| burnDuration | Int32Value | 焚烧时长 |
| minSeq | Int64Value | 最小序列号 |
| maxSeq | Int64Value | 最大序列号 |
| groupAtType | Int32Value | @类型 |
| msgDestructTime | Int64Value | 消息销毁时间 |
| isMsgDestruct | BoolValue | 消息销毁开关 |

### MsgData

| 字段 | 类型 | 说明 |
|------|------|------|
| sendID | string | 发送者ID |
| recvID | string | 接收者ID |
| groupID | string | 群组ID |
| clientMsgID | string | 客户端消息ID |
| serverMsgID | string | 服务端消息ID |
| senderPlatformID | int32 | 发送者平台ID |
| senderNickname | string | 发送者昵称 |
| senderFaceURL | string | 发送者头像URL |
| sessionType | int32 | 会话类型 |
| msgFrom | int32 | 消息来源 |
| contentType | int32 | 内容类型 |
| content | bytes | 消息内容(base64编码) |
| seq | int64 | 序列号 |
| sendTime | int64 | 发送时间 |
| createTime | int64 | 创建时间 |
| status | int32 | 消息状态 |
| isRead | bool | 是否已读 |
| options | map\<string, bool\> | 消息选项 |
| offlinePushInfo | OfflinePushInfo | 离线推送信息 |
| atUserIDList | string[] | @用户ID列表 |
| attachedInfo | string | 附加信息 |
| ex | string | 扩展字段 |

### OfflinePushInfo

| 字段 | 类型 | 说明 |
|------|------|------|
| title | string | 推送标题 |
| desc | string | 推送描述 |
| ex | string | 扩展字段 |
| iOSPushSound | string | iOS推送声音 |
| iOSBadgeCount | bool | iOS角标 |
| signalInfo | string | 信令信息 |

### FriendInfo

| 字段 | 类型 | 说明 |
|------|------|------|
| ownerUserID | string | 友谊拥有者ID |
| remark | string | 备注 |
| createTime | int64 | 添加时间 |
| friendUser | [UserInfo](#userinfo) | 好友用户信息 |
| addSource | int32 | 添加来源 |
| operatorUserID | string | 操作人ID |
| ex | string | 扩展字段 |
| isPinned | bool | 是否置顶 |

### BlackInfo

| 字段 | 类型 | 说明 |
|------|------|------|
| ownerUserID | string | 拥有者ID |
| createTime | int64 | 添加黑名单时间 |
| blackUserInfo | PublicUserInfo | 被拉黑用户信息 |
| addSource | int32 | 来源 |
| operatorUserID | string | 操作人ID |
| ex | string | 扩展字段 |

### FriendRequest

| 字段 | 类型 | 说明 |
|------|------|------|
| fromUserID | string | 申请人ID |
| fromNickname | string | 申请人昵称 |
| fromFaceURL | string | 申请人头像 |
| toUserID | string | 接收人ID |
| toNickname | string | 接收人昵称 |
| toFaceURL | string | 接收人头像 |
| handleResult | int32 | 处理结果 |
| reqMsg | string | 申请消息 |
| createTime | int64 | 申请时间 |
| handlerUserID | string | 处理人ID |
| handleMsg | string | 处理消息 |
| handleTime | int64 | 处理时间 |
| ex | string | 扩展字段 |

### GroupRequest

| 字段 | 类型 | 说明 |
|------|------|------|
| userInfo | PublicUserInfo | 申请人信息 |
| groupInfo | [GroupInfo](#groupinfo) | 群信息 |
| handleResult | int32 | 处理结果 |
| reqMsg | string | 申请消息 |
| handleMsg | string | 处理消息 |
| reqTime | int64 | 申请时间 |
| handleUserID | string | 处理人ID |
| handleTime | int64 | 处理时间 |
| ex | string | 扩展字段 |
| joinSource | int32 | 加入来源 |
| inviterUserID | string | 邀请人ID |

### RequestPagination

| 字段 | 类型 | 说明 |
|------|------|------|
| pageNumber | int32 | 页码(从1开始) |
| showNumber | int32 | 每页条数 |

### PublicUserInfo

| 字段 | 类型 | 说明 |
|------|------|------|
| userID | string | 用户ID |
| nickname | string | 昵称 |
| faceURL | string | 头像URL |
| ex | string | 扩展字段 |
