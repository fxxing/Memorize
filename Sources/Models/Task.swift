//
//  Task.swift
//  Memorize
//
//  Created by Fengxiang Xing on 2/5/16.
//  Copyright © 2016 Fengxiang Xing. All rights reserved.
//

import Foundation


enum TaskType {
    case Learn
    case Review
    case ReviewToday
}


class Task {
    var type = TaskType.Learn
    var list = 0
    var done = false
    var count = 0
}