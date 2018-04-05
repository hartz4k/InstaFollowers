
//
//  ModelManager.swift
//  DataBaseDemo
//
//  Created by Krupa-iMac on 05/08/14.
//  Copyright (c) 2014 TheAppGuruz. All rights reserved.
//

import UIKit

let sharedInstance = ModelManager()
let sharedInstanceQueue = ModelManager()

class ModelManager: NSObject {
    
var database: FMDatabase? = nil
    
    var databaseQueue : FMDatabaseQueue? = nil
    
    class var instance: ModelManager
    {
        sharedInstance.database = FMDatabase(path: Util.getPath("InstaFollowers.sqlite"))

        let path = Util.getPath("InstaFollwers.sqlite")
        print("path : \(path)")
        return sharedInstance
    }
    
    class var instanceQueue: ModelManager
    {
        sharedInstanceQueue.databaseQueue = FMDatabaseQueue(path: Util.getPath("InstaFollowers.sqlite"))
        
        let path = Util.getPath("InstaFollwers.sqlite")
        print("path : \(path)")
        return sharedInstanceQueue
    }
    
    func Insert_UserDetail(_ UserDetail: [String:AnyObject]) -> Bool
    {
        
        print(" \(UserDetail)")
        sharedInstance.database!.open()
        sharedInstance.database?.beginTransaction()
        
        if (sharedInstance.database!.open()){
            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO tbl_User (userId,accessToken,userName,active) VALUES (:userId, :accessToken, :userName, :active)", withParameterDictionary : UserDetail as [AnyHashable: Any]);
            
            print("InsertData : \(isInserted))")
            
            sharedInstance.database?.commit()
            
            sharedInstance.database!.close()
            
            return isInserted
        }
        
        return false
    }
    
    func getUserData()  -> [[String:AnyObject]]
    {
        
        var userArray = [[String:AnyObject]]()
        sharedInstance.database!.open()
        sharedInstance.database?.beginTransaction()
        
        let querySQL = "select * from tbl_User"
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        if (resultSet != nil) {
            while resultSet?.next() == true {
                var DicObj = [String:AnyObject]()
                DicObj["userId"] = resultSet!.string(forColumn: "userId") as AnyObject
                DicObj["accessToken"] = resultSet!.string(forColumn: "accessToken") as AnyObject
                DicObj["userName"] = resultSet!.string(forColumn: "userName") as AnyObject
                DicObj["active"] = resultSet!.string(forColumn: "active") as AnyObject
                userArray.append(DicObj)
            }
        }
        sharedInstance.database?.commit()
        sharedInstance.database!.close()
        
        return userArray
        
    }
    
    func updateUserData(_ userId:Int)
    {
        sharedInstance.database!.open()
        sharedInstance.database?.beginTransaction()
        
        let querySQL = "update tbl_User set active = 0 where userId = \(userId)"
        let  xx : Bool
        xx =  sharedInstance.database!.executeUpdate(querySQL, withArgumentsIn: nil)
        print("query : \(xx)")
        
        sharedInstance.database?.commit()
        sharedInstance.database!.close()
    }
    
    func updateActiveUser(_ userId:Int)
    {
        sharedInstance.database!.open()
        sharedInstance.database?.beginTransaction()
        
        let querySQL = "update tbl_User set active = 1 where userId = \(userId)"
        let  xx : Bool
        xx =  sharedInstance.database!.executeUpdate(querySQL, withArgumentsIn: nil)
        print("query : \(xx)")
        
        sharedInstance.database?.commit()
        sharedInstance.database!.close()
    }
    
    func deleteUserData()
    {
        sharedInstance.database!.open()
        sharedInstance.database?.beginTransaction()
        
        let querySQL = "delete FROM tbl_User"
        
//        var querySQL1 = "DELETE FROM Illustration_media where drill_id =('\(DrillId)')"
        let  xx : Bool
        xx =  sharedInstance.database!.executeUpdate(querySQL, withArgumentsIn: nil)
        print("query : \(xx)")
        
        sharedInstance.database?.commit()
        sharedInstance.database!.close()
    }
    
    func deleteSingleUserData(_ userId:Int)
    {
        sharedInstance.database!.open()
        sharedInstance.database?.beginTransaction()
        
        let querySQL = "DELETE FROM tbl_User where userId =('\(userId)')"
        
        let  xx : Bool
        xx =  sharedInstance.database!.executeUpdate(querySQL, withArgumentsIn: nil)
        print("query : \(xx)")
        
        sharedInstance.database?.commit()
        sharedInstance.database!.close()
    }
    
    /*
    func get_drill_result_time(_ drillResultMetrixId:String) -> String
    {
        
        var result_str = ""
        sharedInstance.database!.open()
        
        // sharedInstance.database?.beginTransaction()
        
        let querySQL = "select drillResultTime from Result_Metrix where drillResultMetrixId = \(drillResultMetrixId)"
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        while resultSet?.next() == true
        {
            
            result_str = resultSet!.string(forColumn: "drillResultTime")
        }
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
        
        
        return result_str
    }
    
    func get_drill_packge(_ drillid:String) -> String
    {
        
        var result_str = ""
        sharedInstance.database!.open()
        
        // sharedInstance.database?.beginTransaction()
        
        let querySQL = "select main_category_name,package_name,category_name from Drill_Info DI  inner join Drill_category_master DM on DM.category_id = DI.category_id inner join Drill_package DP on DM.drill_package_id = DP.drill_package_id inner join Drill_main_category_master DMC on DP.main_category_id = DMC.main_category_id  where DI.drill_id = \(drillid)"
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        while resultSet?.next() == true
        {
            
            result_str = resultSet!.string(forColumn: "main_category_name") + "/" + resultSet!.string(forColumn: "package_name") + "/" + resultSet!.string(forColumn: "category_name")
            
        }
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
        
        return result_str
    }
    
func Database_TypesOfPurpose(_ PurposeType: NSMutableArray)
{
       
        
    sharedInstance.database!.open()
    // sharedInstance.database?.beginTransaction()

        let querySQL = "select * from Purpose_type_master"
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
         let Purpose_type_Id: String = "purpose_type_id"
        let purpose_type_Name: String = "Purpose_type_Name"
        if (resultSet != nil) {
            while resultSet?.next() == true {
                print("PurposeTypeID : \(resultSet!.string(forColumn: Purpose_type_Id))")
                print("PurposeTypeName : \(resultSet!.string(forColumn: purpose_type_Name))")
                
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj .setValue(resultSet!.string(forColumn: Purpose_type_Id), forKey: "PurposeTypeID")
                DicObj .setValue(resultSet!.string(forColumn: purpose_type_Name), forKey: "PurposeTypeName")
                PurposeType.add(DicObj)
            }
            
        }
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
    
    }
    
    func get_foucus_purpose(_ types:String,typeid:String) -> String
    {
        var querySQL = ""
        var resultStr = ""
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        if types == "focus"
        {
             querySQL = "select focus_type_Name from focus_Master where focus_type_id = \(typeid)"
            
            let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
            if (resultSet != nil) {
                while resultSet?.next() == true
                {
                   resultStr = resultSet!.string(forColumn: "focus_type_Name")
                }
            }
        }
        else
        {
             querySQL = "select Purpose_type_Name from Purpose_type_master where purpose_type_id = \(typeid)"
            let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
            if (resultSet != nil) {
                while resultSet?.next() == true
                {
                    resultStr = resultSet!.string(forColumn: "Purpose_type_Name")
                }
            }
        }
        
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        
        return resultStr
        
    }
    
    func Database_TypesOfFocus(_ FocusType: NSMutableArray)
    {
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

        let querySQL = "select * from focus_Master"
        print("SQLquery : \(querySQL))")
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        print("ResultSet : \(resultSet))")
        let Focus_type_Id: String = "focus_type_id"
        let Focus_type_Name: String = "focus_type_Name"
        if (resultSet != nil) {
            while resultSet?.next() == true {
                print("FocusTypeID : \(resultSet!.string(forColumn: Focus_type_Id))")
                print("FocusTypeName : \(resultSet!.string(forColumn: Focus_type_Name))")
                
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj .setValue(resultSet!.string(forColumn: Focus_type_Id), forKey: "FocusTypeID")
                DicObj .setValue(resultSet!.string(forColumn: Focus_type_Name), forKey: "FocusTypeName")
                FocusType.add(DicObj)
            }
        }
         // sharedInstance.database?.commit()

        //  sharedInstance.database!.close()
    }
    
    
func Database_TypesOfDifficulty(_ DifficultyType: NSMutableArray)
{
    
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

        let querySQL = "select * from diffculty_Master"
        print("SQLquery : \(querySQL))")
         let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        print("ResultSet : \(resultSet))")
        let Difficulty_type_Id: String = "diffculty_type_id"
        let Difficulty_type_Name: String = "diffculty_type_name"
        if (resultSet != nil) {
            while resultSet?.next() == true
            {
                print("difficultyTypeID : \(resultSet!.string(forColumn: Difficulty_type_Id))")
                print("difficultyTypeName : \(resultSet!.string(forColumn: Difficulty_type_Name))")
                
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj .setValue(resultSet!.string(forColumn: Difficulty_type_Id), forKey: "Difficulty_typeid")
                DicObj .setValue(resultSet!.string(forColumn: Difficulty_type_Name), forKey: "Difficulty_type_Name")
                DifficultyType.add(DicObj)
            }
        }
     // sharedInstance.database?.commit()

        //  sharedInstance.database!.close()
    }
    
    func Database_TypesOfTraining(_ TrainingType: NSMutableArray)
    {
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

        let querySQL = "select * from training_Master"
        print("SQLquery : \(querySQL))")
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        print("ResultSet : \(resultSet))")
        let Training_type_Id: String = "traning_type_id"
        let Training_type_Name: String = "traning_type_Name"
        if (resultSet != nil) {
            while resultSet?.next() == true {
                print("TrainingTypeID : \(resultSet!.string(forColumn: Training_type_Id))")
                print("TrainingTypeName : \(resultSet!.string(forColumn: Training_type_Name))")
                
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj .setValue(resultSet!.string(forColumn: Training_type_Id), forKey: "traning_type_id")
                DicObj .setValue(resultSet!.string(forColumn: Training_type_Name), forKey: "traning_type_Name")
                TrainingType.add(DicObj)
            }
         }
         // sharedInstance.database?.commit()

        //  sharedInstance.database!.close()
    }
    
    func Database_TypesOfSituation(_ SituationType: NSMutableArray)
    {
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

        let querySQL = "select * from No_of_situation"
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        let Situation_type_Id: String = "situation_type_id"
        let Situation_type_Name: String = "situation_type_name"
        let Situation_row_Value: String = "row_value"

        if (resultSet != nil) {
            while resultSet?.next() == true {
                print("SituationTypeID : \(resultSet!.string(forColumn: Situation_type_Id))")
                print("SituationTypeName : \(resultSet!.string(forColumn: Situation_type_Name))")
                print("SituationTypeName : \(resultSet!.string(forColumn: Situation_row_Value))")

                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj .setValue(resultSet!.string(forColumn: Situation_type_Id), forKey: "situation_type_id")
                DicObj .setValue(resultSet!.string(forColumn: Situation_type_Name), forKey: "situation_type_name")
                 DicObj .setValue(resultSet!.string(forColumn: Situation_row_Value), forKey: "row_value")
                SituationType.add(DicObj)
            }
        }
         // sharedInstance.database?.commit()

        //  sharedInstance.database!.close()
    }

    func check_plan_tran_id1(_ tranid:String,planId:String) -> Bool
    {
        var check = false
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        let querySQL = "select * from Result_Metrix where drillPlanTransactionId = \(tranid) and  planId = \(planId)"
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        if (resultSet != nil) {
            while resultSet?.next() == true
            {
                check = true
            }
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        
        return check
        
    }
    
    func get_plan_category(_ categoty_id:String) -> String
    {
        
        var category_name = ""
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        let querySQL = "select * from plan_category_master where plan_category_id = \(categoty_id) "
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        if (resultSet != nil) {
            while resultSet?.next() == true
            {
             category_name  =  resultSet!.string(forColumn: "category_name")
            }
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        
        return category_name
    }

    func get_drill_resultmatid(_ tranid:String,planid:String,reptation:String) -> String
    {
        var mat_id = ""
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        var querySQL = ""
        
        if reptation == ""
        {
            querySQL = "select * from Result_Metrix where drillPlanTransactionId = \(tranid) and planId = \(planid)"

        }
        else
        {
            querySQL = "select * from Result_Metrix where drillPlanTransactionId = \(tranid) and repetation  = \(reptation) and planId = \(planid)"
        }
        
                 let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        if (resultSet != nil) {
            while resultSet?.next() == true
            {
               mat_id = (resultSet!.string(forColumn: "drillResultMetrixId"))
            }
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        
        return mat_id
    }

    
    
    func check_plan_tran_id(_ tranid:String,current_repetation:String,planId:String) -> Bool
    {

        var check = false
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        
//        let querySQL = sharedInstance.database!.executeQuery("select * from Result_Metrix where drillPlanTransactionId = \(tranid) and repetation  = \(current_repetation) and planId = \(planId)", withArgumentsIn: nil)
//        
//        
//        if (querySQL != nil)
//        {
//            check = false
//        }
//        else
//        {
//            check = true
//        }
        
        
        let querySQL = "select * from Result_Metrix where drillPlanTransactionId = \(tranid) and repetation  = \(current_repetation) and planId = \(planId)"
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        if (resultSet != nil) {
            while resultSet?.next() == true
            {
                check = true
            }
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        
        return check
    }
    
    func Database_DrillMainCategoty()  -> NSMutableArray
    {
        
        let SituationType = NSMutableArray()
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

        let querySQL = "select * from Drill_main_category_master"
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        let main_category_id: String = "main_category_id"
        let main_category_name: String = "main_category_name"
        let color_id: String = "color_id"
        
        if (resultSet != nil) {
            while resultSet?.next() == true {
                print("MainCategoryID : \(resultSet!.string(forColumn: main_category_id))")
                print("MainCategoryName : \(resultSet!.string(forColumn: main_category_name))")
                print("colorid : \(resultSet!.string(forColumn: color_id))")
                
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj .setValue(resultSet!.string(forColumn: main_category_id), forKey: "main_category_id")
                DicObj .setValue(resultSet!.string(forColumn: main_category_name), forKey: "main_category_name")
                DicObj .setValue(resultSet!.string(forColumn: color_id), forKey: "color_id")
                SituationType.add(DicObj)
            }
        }
        
        let dummy_array = NSMutableArray()
        dummy_array.add(SituationType[2])
        dummy_array.add(SituationType[0])
        dummy_array.add(SituationType[3])
        dummy_array.add(SituationType[1])
        dummy_array.add(SituationType[4])
        dummy_array.add(SituationType[5])
        
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        
        return dummy_array
        
    }
    
    func Database_DrillDatabase(_ MainCategoryId1: NSString, MainData:NSMutableArray)
    {
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
       
        let querySQL = NSString(format:"SELECT * FROM Drill_category_master dcm,Drill_package dp,Drill_main_category_master dmcm WHERE dmcm.main_category_id=%@ and dp.drill_package_id = dcm.drill_package_id and dmcm.main_category_id = dp.main_category_id order by category_id", MainCategoryId1) as String

        print("SqlQuery : \(querySQL)")

        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)

        let category_id: String = "category_id"
        let drill_package_id: String = "drill_package_id"
        let category_name: String = "category_name"
        let color_id: String = "color_id"
       
        let drill_package_id1: String = "drill_package_id"
        let main_category_id: String = "main_category_id"
        
        let color_id2: String = "color_id"
        let package_name: String = "package_name"
        let main_category_name: String = "main_category_name"
        let color_id3: String = "color_id"
        
        if (resultSet != nil) {
            while resultSet?.next() == true {
               
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj .setValue(resultSet!.string(forColumn: category_id), forKey: "category_id")
                DicObj .setValue(resultSet!.string(forColumn: drill_package_id), forKey: "drill_package_id")
                DicObj .setValue(resultSet!.string(forColumn: category_name), forKey: "category_name")
                DicObj .setValue(resultSet!.string(forColumn: color_id), forKey: "color_id")
                DicObj .setValue(resultSet!.string(forColumn: drill_package_id1), forKey: "drill_package_id1")
                DicObj .setValue(resultSet!.string(forColumn: main_category_id), forKey: "main_category_id")
                DicObj .setValue(resultSet!.string(forColumn: color_id2), forKey: "color_id")
                DicObj .setValue(resultSet!.string(forColumn: package_name), forKey: "package_name")
                DicObj .setValue(resultSet!.string(forColumn: main_category_name), forKey: "main_category_name")
                DicObj .setValue(resultSet!.string(forColumn: color_id3), forKey: "color_id")
                
                MainData.add(DicObj)
            }
        }
         // sharedInstance.database?.commit()

        //  sharedInstance.database!.close()
    }
    
    func Database_DisplayMatrix(_ Matrix: NSMutableArray, SID:NSString) {
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

        let querySQL:String
    
        querySQL = "select * from Matrix_master"
       
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        let matrix_id: String = "metrix_id"
        let type: String = "type"
        let row: String = "row"
        let column: String = "col"
        
        if (resultSet != nil) {
            while resultSet?.next() == true {
                
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj .setValue(resultSet!.string(forColumn: matrix_id), forKey: "metrix_id")
                DicObj .setValue(resultSet!.string(forColumn: type), forKey: "type")
                DicObj .setValue(resultSet!.string(forColumn: row), forKey: "row")
                DicObj .setValue(resultSet!.string(forColumn: column), forKey: "col")

                Matrix.add(DicObj)
            }
        }
         // sharedInstance.database?.commit()

        //  sharedInstance.database!.close()
    }
    
    func Database_ShotArray(_ ShotArray: NSMutableArray)  {
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

        let querySQL = "select * from shot_Type_Master"
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        let ShotId_id: String = "shot_type_id"
        let ShotName: String = "shot_type_name"

        if (resultSet != nil) {
            while resultSet?.next() == true {
                print("ShotTypeId : \(resultSet!.string(forColumn: ShotId_id))")
                print("ShotTypeName : \(resultSet!.string(forColumn: ShotName))")
              
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj .setValue(resultSet!.string(forColumn: ShotId_id), forKey: "shot_type_id")
                DicObj .setValue(resultSet!.string(forColumn: ShotName), forKey: "shot_type_name")
                
                ShotArray.add(DicObj)
            }
            
        }
         // sharedInstance.database?.commit()

        //  sharedInstance.database!.close()
    }
    
    func Get_pre_Database_PlanArray(_ PlanArray: NSMutableArray, userId : NSString)
    {
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        let querySQL = NSString(format:"select * from Plan  where planTypeId != 4 order by plan_id desc") as String
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        let Plan_id: String = "plan_id"
        let PlancatID: String = "plan_category_id"
        let Plan_title: String = "plan_title"
        let Plan_Desc: String = "Plan_Desc"
        let PlanTypeID: String = "planTypeId"
        
        if (resultSet != nil) {
            while resultSet?.next() == true {
                print("plan_id : \(resultSet!.string(forColumn: Plan_id))")
                print("plan_category_id : \(resultSet!.string(forColumn: PlancatID))")
                print("plan_title : \(resultSet!.string(forColumn: Plan_title))")
                print("Plan_Desc : \(resultSet!.string(forColumn: Plan_Desc))")
                print("PlanTypeID : \(resultSet!.string(forColumn: PlanTypeID))")
                
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                
                DicObj .setValue(resultSet!.string(forColumn: Plan_id), forKey: "plan_id")
                DicObj .setValue(resultSet!.string(forColumn: PlancatID), forKey: "plan_category_id")
                DicObj .setValue(resultSet!.string(forColumn: Plan_title), forKey: "plan_title")
                DicObj .setValue(resultSet!.string(forColumn: PlanTypeID), forKey: "PlanTypeID")
                DicObj .setValue(resultSet!.string(forColumn: Plan_Desc), forKey: "Plan_Desc")
                PlanArray.add(DicObj)
            }
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
    }
    
    
    func Database_PlanArray1(_ PlanArray: NSMutableArray, userId : NSString)
    {
        let planDrillData: NSMutableArray = NSMutableArray()
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        let querySQL = NSString(format:"select * from Plan  where  planTypeId = 3 and (inqueue = 1 or isforcefully = 1) order by plan_id desc") as String

//        let querySQL = NSString(format:"select * from Plan  where  planTypeId = 3 and from_student = 1 order by plan_id desc") as String
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        let Plan_id: String = "plan_id"
        let PlancatID: String = "plan_category_id"
        let Plan_title: String = "plan_title"
        let Plan_Desc: String = "Plan_Desc"
        let PlanTypeID: String = "planTypeId"
        
        if (resultSet != nil) {
            while resultSet?.next() == true {
                print("plan_id : \(resultSet!.string(forColumn: Plan_id))")
                print("plan_category_id : \(resultSet!.string(forColumn: PlancatID))")
                print("plan_title : \(resultSet!.string(forColumn: Plan_title))")
                print("Plan_Desc : \(resultSet!.string(forColumn: Plan_Desc))")
                print("PlanTypeID : \(resultSet!.string(forColumn: PlanTypeID))")
                
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                
                DicObj .setValue(resultSet!.string(forColumn: Plan_id), forKey: "plan_id")
                DicObj .setValue(resultSet!.string(forColumn: PlancatID), forKey: "plan_category_id")
                DicObj .setValue(resultSet!.string(forColumn: Plan_title), forKey: "plan_title")
                DicObj .setValue(resultSet!.string(forColumn: PlanTypeID), forKey: "PlanTypeID")
                DicObj .setValue(resultSet!.string(forColumn: Plan_Desc), forKey: "Plan_Desc")
                
                PlanArray.add(DicObj)
            }
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
    }
   
    func Database_PlanArray(_ PlanArray: NSMutableArray, userId : NSString)
    {
        
        let planDrillData: NSMutableArray = NSMutableArray()
        
       sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

        // var querySQL = NSString(format:"select * from Plan WHERE user_id = %@",userId) as String
        let querySQL = NSString(format:"select * from Plan  where planTypeId = 2 or planTypeId = 1 or planTypeId = 3 and (inqueue = 1 or isforcefully = 1 and from_student !=1) order by plan_id desc") as String

        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        let Plan_id: String = "plan_id"
        let PlancatID: String = "plan_category_id"
        let Plan_title: String = "plan_title"
        let Plan_Desc: String = "Plan_Desc"
        let PlanTypeID: String = "planTypeId"
        
        if (resultSet != nil) {
            while resultSet?.next() == true {
                print("plan_id : \(resultSet!.string(forColumn: Plan_id))")
                print("plan_category_id : \(resultSet!.string(forColumn: PlancatID))")
                print("plan_title : \(resultSet!.string(forColumn: Plan_title))")
                print("Plan_Desc : \(resultSet!.string(forColumn: Plan_Desc))")
                print("PlanTypeID : \(resultSet!.string(forColumn: PlanTypeID))")

                let DicObj:NSMutableDictionary = NSMutableDictionary()
                
                DicObj .setValue(resultSet!.string(forColumn: Plan_id), forKey: "plan_id")
                DicObj .setValue(resultSet!.string(forColumn: PlancatID), forKey: "plan_category_id")
                DicObj .setValue(resultSet!.string(forColumn: Plan_title), forKey: "plan_title")
                DicObj .setValue(resultSet!.string(forColumn: PlanTypeID), forKey: "PlanTypeID")
                DicObj .setValue(resultSet!.string(forColumn: Plan_Desc), forKey: "Plan_Desc")

                PlanArray.add(DicObj)
            }
        }
         // sharedInstance.database?.commit()

        //  sharedInstance.database!.close()
    }
    
    
    func update_total_repetation(_ planid:String,repetation:String)
    {
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        let querySQL = "update Plan set repetation = \(repetation) where plan_id = \(planid)"
        let  xx : Bool
        xx =  sharedInstance.database!.executeUpdate(querySQL, withArgumentsIn: nil)
        print("query : \(xx)")
        
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        
    }
    
    func update_repetation(_ planid:String,repetation:String)
    {
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        let querySQL = "update Plan set completedRepetation = \(repetation) where plan_id = \(planid)"
        let  xx : Bool
        xx =  sharedInstance.database!.executeUpdate(querySQL, withArgumentsIn: nil)
        print("query : \(xx)")
        
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
    }
    
    func update_forcefully(_ query:String)
    {
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
       
        let  xx : Bool
        xx =  sharedInstance.database!.executeUpdate(query, withArgumentsIn: nil)
        print("query : \(xx)")
        
        
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        
    }
    
    
    
    func get_plantran_byplanid(_ planid:String) -> NSMutableArray
    {
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        let plan_array = NSMutableArray()
        
        let querySQL = "select plan_transaction_id from Drill_plan_transaction where plan_id =  \(planid)"
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        if (resultSet != nil) {
            while resultSet?.next() == true
            {
                plan_array.add(resultSet!.string(forColumn: "plan_transaction_id"))
            }
        }

         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        
        return plan_array
        
    }
    
    func get_repetation(_ planid:String) -> NSArray
    {
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        var completedrepetation = ""
        var totalrepetation = ""
        let querySQL = "select completedRepetation,repetation from Plan where plan_id = \(planid)"
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
               if (resultSet != nil) {
            while resultSet?.next() == true
            {
                completedrepetation = resultSet!.string(forColumn: "completedRepetation")
                totalrepetation = resultSet!.string(forColumn: "repetation")
            }
        }
        
         let return_array = [completedrepetation,totalrepetation] as! NSArray
    
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        
        return return_array
        
    }
    
    
    func GetDrillByTraningTypes(_ main_category_id:  String, DrillArray: NSMutableArray)
    {
        
    var  userid = UserDefaults.standard.object(forKey: "UserId") as? String
        
        if userid == nil
        {
            userid = String(format: "%d ", (UserDefaults.standard.object(forKey: "UserId") as? Int)!)
        }
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

        let querySQL = "select drill_id,title,estimat_time,no_of_shots,diffculty_type_id,focus_type_id,purpose_type_id from Drill_Info DI inner join Drill_category_master DCM on DI.category_id = DCM.category_id  inner join  Drill_package DP on DCM.drill_package_id = DP.drill_package_id inner join Drill_main_category_master DMCM on  DMCM.main_category_id = DP.main_category_id where DMCM.main_category_id = \(main_category_id) AND DI.CreatedbyuserId = \(userid!) AND (DI.drillTypeid = 1 or DI.drillTypeid = 2)"
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)

        if (resultSet != nil) {
            while resultSet?.next() == true
            {
                let tmp_dic : NSMutableDictionary = ["drill_id" :resultSet!.string(forColumn: "drill_id"),
                                                     "Drill_name" :resultSet!.string(forColumn: "title"),"estimat_time":resultSet!.string(forColumn: "estimat_time"),"shots":Int( resultSet!.string(forColumn: "no_of_shots"))!,"dificulty":Int(resultSet!.string(forColumn: "diffculty_type_id"))!,"focus":Int(resultSet!.string(forColumn: "focus_type_id"))!,"purpose":Int(resultSet!.string(forColumn: "purpose_type_id"))!]
                DrillArray.add(tmp_dic)
            }
        }
        
         // sharedInstance.database?.commit()

        //  sharedInstance.database!.close()
    }
    
    func AddDrillData(_ All_Drill_WS: NSMutableArray)
    {
        
        
        
        print("DrillDetailInfo : \(All_Drill_WS))")
        
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        for i in 0 ..< All_Drill_WS.count 
        {
            
            
            var DrillDetailInfo : NSMutableDictionary = NSMutableDictionary()
            DrillDetailInfo = All_Drill_WS.object(at: i) as! NSMutableDictionary
            print("\(DrillDetailInfo)")
            
            
            if let isPremium = DrillDetailInfo["isPremium"] as? String
            {
                
            }
            else
            {
                DrillDetailInfo.setValue("0", forKey: "isPremium")
            }
            
            if let fromPremiumPlan = DrillDetailInfo["fromPremiumPlan"] as? String
            {
                
            }
            else
            {
                DrillDetailInfo.setValue("0", forKey: "fromPremiumPlan")
            }
            
            print("\(DrillDetailInfo)")
          
            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Drill_Info(drill_id,title, abstract_description, long_description, estimat_time, hundred_percent_equi_value, category_id, diffculty_type_id, focus_type_id, shot_type_id, traning_type_id, purpose_type_id, situation_type_id, metrix_id, no_of_shots, drillTypeid, CreatedbyuserId, Scorecard_desc,isPremium,fromPremiumPlan,from_student) VALUES (:drill_id, :title, :abstract_description, :long_description, :estimat_time, :hundred_percent_equi_value, :category_id, :diffculty_type_id, :focus_type_id, :shot_type_id, :traning_type_id, :purpose_type_id, :situation_type_id, :metrix_id, :no_of_shots, :drillTypeid, :CreatedbyuserId, :Scorecard_desc,:isPremium,:fromPremiumPlan,:from_student)", withParameterDictionary : DrillDetailInfo as! [AnyHashable: Any]);
                print("InsertData : \(isInserted))")
            
            
        }

         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        
        
    }
    
    
    func AddDrillDataFromTrain(_ All_Drill_WS: NSMutableArray)
    {
        print("DrillDetailInfo : \(All_Drill_WS))")
        
        
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        for i in 0 ..< All_Drill_WS.count
        {
            
            
            var DrillDetailInfo : NSMutableDictionary = NSMutableDictionary()
            DrillDetailInfo = All_Drill_WS.object(at: i) as! NSMutableDictionary
            print("\(DrillDetailInfo)")
            
            var DrillDetailInfo1 : NSMutableDictionary = NSMutableDictionary()

            DrillDetailInfo1.setValue(DrillDetailInfo.value(forKey: "drillId"), forKey: "drill_id")
            DrillDetailInfo1.setValue(DrillDetailInfo.value(forKey: "drill"), forKey: "title")
            DrillDetailInfo1.setValue(DrillDetailInfo.value(forKey: "abstractDescription"), forKey: "abstract_description")
            DrillDetailInfo1.setValue(DrillDetailInfo.value(forKey: "estimatTime"), forKey: "estimat_time")
            DrillDetailInfo1.setValue(DrillDetailInfo.value(forKey: "Equivalent_Value"), forKey: "hundred_percent_equi_value")
            DrillDetailInfo1.setValue(DrillDetailInfo.value(forKey: "drillCategoryId"), forKey: "category_id")
            DrillDetailInfo1.setValue(DrillDetailInfo.value(forKey: "diffcultyTypeId"), forKey: "diffculty_type_id")
            DrillDetailInfo1.setValue(DrillDetailInfo.value(forKey: "focusTypeId"), forKey: "focus_type_id")
            DrillDetailInfo1.setValue(DrillDetailInfo.value(forKey: "shotTypeId"), forKey: "shot_type_id")
            DrillDetailInfo1.setValue(DrillDetailInfo.value(forKey: "traningTypeId"), forKey: "traning_type_id")
            DrillDetailInfo1.setValue(DrillDetailInfo.value(forKey: "purposeTypeId"), forKey: "purpose_type_id")
            DrillDetailInfo1.setValue(DrillDetailInfo.value(forKey: "situationId"), forKey: "situation_type_id")
            DrillDetailInfo1.setValue(DrillDetailInfo.value(forKey: "matrixId"), forKey: "metrix_id")
            DrillDetailInfo1.setValue(DrillDetailInfo.value(forKey: "numberOfShots"), forKey: "no_of_shots")
            DrillDetailInfo1.setValue(DrillDetailInfo.value(forKey: "drillTypeId"), forKey: "drillTypeid")
            DrillDetailInfo1.setValue(DrillDetailInfo.value(forKey: "longDescription"), forKey: "long_description")
            DrillDetailInfo1.setValue("1", forKey: "from_student")
            DrillDetailInfo1.setValue("1", forKey: "fromPremiumPlan")
            DrillDetailInfo1.setValue("0", forKey: "isPremium")
            DrillDetailInfo1.setValue(DrillDetailInfo.value(forKey: "Scorecard_description"), forKey: "Scorecard_desc")
            DrillDetailInfo1.setValue(DrillDetailInfo.value(forKey: "createdByUserId"), forKey: "CreatedbyuserId")
            
            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Drill_Info(drill_id,title, abstract_description, long_description, estimat_time, hundred_percent_equi_value, category_id, diffculty_type_id, focus_type_id, shot_type_id, traning_type_id, purpose_type_id, situation_type_id, metrix_id, no_of_shots, drillTypeid, CreatedbyuserId, Scorecard_desc,isPremium,fromPremiumPlan,from_student) VALUES (:drill_id, :title, :abstract_description, :long_description, :estimat_time, :hundred_percent_equi_value, :category_id, :diffculty_type_id, :focus_type_id, :shot_type_id, :traning_type_id, :purpose_type_id, :situation_type_id, :metrix_id, :no_of_shots, :drillTypeid, :CreatedbyuserId, :Scorecard_desc,:isPremium,:fromPremiumPlan,:from_student)", withParameterDictionary : DrillDetailInfo1 as! [AnyHashable: Any]);
            print("InsertData : \(isInserted))")
            
            
         }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
     }
    
    func Insert_All_Drill_WS(_ All_Drill_WS: NSMutableArray,action:String)
    {
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

        for i in 0 ..< All_Drill_WS.count
        {
            
            var DrillDetailInfo : NSMutableDictionary = NSMutableDictionary()
            DrillDetailInfo = All_Drill_WS.object(at: i) as! NSMutableDictionary
            
        if let isPremium = DrillDetailInfo["isPremium"] as? String
        {
            
        }
            else
        {
            DrillDetailInfo.setValue("0", forKey: "isPremium")
        }
            
            if let fromPremiumPlan = DrillDetailInfo["fromPremiumPlan"] as? String
            {
                
            }
            else
            {
                DrillDetailInfo.setValue("0", forKey: "fromPremiumPlan")
            }
            
            print("\(DrillDetailInfo)")
            
            var from_student = ""
            if let from_student1 = DrillDetailInfo["from_student"] as? String
            {
                
                 DrillDetailInfo.setValue(from_student1, forKey: "from_student")
            }
            else
            {
                 DrillDetailInfo.setValue("0", forKey: "from_student")
            }
            
            if action == "drillbase"
            {
                
                sharedInstanceQueue.databaseQueue!.inDeferredTransaction { database, rollback in
                    do
                    {
                        let isInserted = sharedInstance.database!.executeUpdate("INSERT OR IGNORE INTO Drill_Info(drill_id, title, abstract_description, long_description, estimat_time, hundred_percent_equi_value, category_id, diffculty_type_id, focus_type_id, shot_type_id, traning_type_id, purpose_type_id, situation_type_id, metrix_id, no_of_shots, drillTypeid, CreatedbyuserId, Scorecard_desc,isPremium,fromPremiumPlan,from_student) VALUES (:drill_id, :title, :abstract_description, :long_description, :estimat_time, :hundred_percent_equi_value, :category_id, :diffculty_type_id, :focus_type_id, :shot_type_id, :traning_type_id, :purpose_type_id, :situation_type_id, :metrix_id, :no_of_shots, :drillTypeid, :userId, :Scorecard_description,:isPremium,:fromPremiumPlan,:from_student)", withParameterDictionary : DrillDetailInfo as! [AnyHashable: Any]);
                        //
                        print("InsertData : \(isInserted))")
                    }
                    catch
                    {
                        rollback!.pointee = true
                        print(error)
                    }
                }
 
            }
            else
            {
                sharedInstanceQueue.databaseQueue!.inDeferredTransaction { database, rollback in
                    do
                    {
                        let isInserted = sharedInstance.database!.executeUpdate("INSERT OR IGNORE INTO Drill_Info(drill_id, title, abstract_description, long_description, estimat_time, hundred_percent_equi_value, category_id, diffculty_type_id, focus_type_id, shot_type_id, traning_type_id, purpose_type_id, situation_type_id, metrix_id, no_of_shots, drillTypeid, CreatedbyuserId, Scorecard_desc,isPremium,fromPremiumPlan,from_student) VALUES (:drill_id, :title, :abstract_description, :long_description, :estimat_time, :hundred_percent_equi_value, :category_id, :diffculty_type_id, :focus_type_id, :shot_type_id, :traning_type_id, :purpose_type_id, :situation_type_id, :metrix_id, :no_of_shots, :drillTypeid, :userId, :Scorecard_desc,:isPremium,:fromPremiumPlan,:from_student)", withParameterDictionary : DrillDetailInfo as! [AnyHashable: Any]);
                        print("InsertData : \(isInserted))")
                    }
                    catch
                    {
                        rollback!.pointee = true
                        print(error)
                    }
                }
                
            }
         }
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
     }
    
    
    
    func drill_by_category(_ main_cat_id:String , typeid:String) -> NSMutableArray
    {

        
        let drill_data = NSMutableArray()
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        let querySQL = "SELECT drill_id,title,estimat_time,no_of_shots,diffculty_type_id,focus_type_id,purpose_type_id FROM Drill_Info di inner join Drill_category_master dcm on di.category_id = dcm.category_id inner join Drill_package dp on dp.drill_package_id = dcm.drill_package_id inner join Drill_main_category_master dmcm on dmcm.main_category_id = dp.main_category_id where dmcm.main_category_id = \(main_cat_id) and di.drillTypeid = \(typeid)"
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        if (resultSet != nil)
            
        {
            
            while resultSet?.next() == true
            {
               
                let tmp_dic : NSMutableDictionary = ["drill_id" :resultSet!.string(forColumn: "drill_id"),
                        "Drill_name" :resultSet!.string(forColumn: "title"),"estimat_time":resultSet!.string(forColumn: "estimat_time"),"shots":Int( resultSet!.string(forColumn: "no_of_shots"))!,"dificulty":Int(resultSet!.string(forColumn: "diffculty_type_id"))!,"focus":Int(resultSet!.string(forColumn: "focus_type_id"))!,"purpose":Int(resultSet!.string(forColumn: "purpose_type_id"))!]
                
                drill_data.add(tmp_dic)
            }
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        return drill_data
    }
    
    
    func b_get_drilldata(_userid : String) -> NSMutableArray
    {
        
        let drill_array = NSMutableArray()
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
         let query = "select drill_id,title,abstract_description,long_description,estimat_time,hundred_percent_equi_value,category_id,diffculty_type_id,focus_type_id,purpose_type_id from Drill_Info"
        
         let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(query, withArgumentsIn: nil)
        
        if (resultSet != nil)
            
        {
            while resultSet?.next() == true
            {
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj.setValue(resultSet!.string(forColumn: "drill_id"), forKey: "drill_id")
                DicObj.setValue(resultSet!.string(forColumn: "title"), forKey: "title")
                DicObj.setValue(resultSet!.string(forColumn: "abstract_description"), forKey: "abstract_description")
                DicObj.setValue(resultSet!.string(forColumn: "long_description"), forKey: "long_description")
                DicObj.setValue(resultSet!.string(forColumn: "estimat_time"), forKey: "estimat_time")
                DicObj.setValue(resultSet!.string(forColumn: "hundred_percent_equi_value"), forKey: "hundred_percent_equi_value")
                DicObj.setValue(resultSet!.string(forColumn: "category_id"), forKey: "category_id")
                DicObj.setValue(resultSet!.string(forColumn: "diffculty_type_id"), forKey: "diffculty_type_id")
                DicObj.setValue(resultSet!.string(forColumn: "focus_type_id"), forKey: "focus_type_id")
                DicObj.setValue(resultSet!.string(forColumn: "purpose_type_id"), forKey: "purpose_type_id")
                DicObj.setValue(resultSet!.string(forColumn: "drillTypeid"), forKey: "drillTypeid")
                
                drill_array.add(DicObj)
            }        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        return drill_array

    }
    
    
    func get_short_lbl(_ drill_id:String) -> String
    {
      var cat_di = ""
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        let querySQL = "SELECT short_label FROM Drill_Info di inner join Drill_category_master dcm on di.category_id = dcm.category_id where di.drill_id = \(drill_id)"
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        if (resultSet != nil)
        {
            
            while resultSet?.next() == true
            {
                cat_di = resultSet!.string(forColumn: "short_label")
            }
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        return cat_di
    }
    
    func ALL_DRILL_DATA(_ userid:String) -> NSMutableArray
    {
        
        let drill_array = NSMutableArray()
        let userid = UserDefaults.standard.string(forKey: "UserId")!
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
//        let querySQL = "SELECT * FROM Drill_Info di, Drill_category_master dcm, Drill_package dp, Drill_main_category_master dmcm, Drill_color_master dcolm,Purpose_type_master pm,focus_Master fm WHERE di.category_id=dcm.category_id AND dp.drill_package_id=dcm.drill_package_id AND dmcm.main_category_id=dp.main_category_id AND dcolm.color_id=dp.color_id AND pm.purpose_type_id =  di.purpose_type_id  AND fm.focus_type_id =  di.focus_type_id AND di.CreatedbyuserId = \(userid) AND (di.drillTypeid = 2 or di.drillTypeid = 1)  order by di.drill_id DESC "
        
        let querySQL = "SELECT * FROM Drill_Info DI inner join Drill_category_master dcm on DI.category_id=dcm.category_id left outer join Drill_color_master dclm on dcm.color_id=dclm.color_id where from_student=0 and drillTypeId !=3 ORDER BY  drill_id desc"
        
//        let querySQL = "SELECT * FROM Drill_Info di, Drill_category_master dcm, Drill_package dp, Drill_main_category_master dmcm, Drill_color_master dcolm,Purpose_type_master pm,focus_Master fm WHERE di.category_id=dcm.category_id AND dp.drill_package_id=dcm.drill_package_id AND dmcm.main_category_id=dp.main_category_id AND dcolm.color_id=dp.color_id AND pm.purpose_type_id =  di.purpose_type_id  AND fm.focus_type_id =  di.focus_type_id AND di.CreatedbyuserId = \(userid) AND (di.drillTypeid != 2)  order by di.drill_id DESC "
 
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        let Drill_ID: String = "drill_id"
        let Drill_Title: String = "title"
        let Drill_Short_DESC: String = "abstract_description"
        let Drill_Long_DESC: String = "long_description"
        let Drill_Est_time: String = "estimat_time"
        let Drill_Equity: String = "hundred_percent_equi_value"
        let Drill_CatID: String = "category_id"
        let Drill_Difficulty_ID: String = "diffculty_type_id"
        let Drill_FocusID: String = "focus_type_id"
        let Drill_ShotID: String = "shot_type_id"
        let Drill_TrainingID: String = "traning_type_id"
        let Drill_PurposeID: String = "purpose_type_id"
        let Drill_SituationID: String = "situation_type_id"
        let Drill_MetrixID: String = "metrix_id"
        
        let CatID: String = "category_id"
        let Drill_Package_ID: String = "drill_package_id"
        let Cat_Name: String = "category_name"
        let Color_ID: String = "color_id"
        let Drill_Package_ID1: String = "drill_package_id"
        let Main_Category_ID: String = "main_category_id"
        let Color_ID1: String = "color_id"
        let Package_Name: String = "package_name"
        let Main_Category_ID1: String = "main_category_id"
        let Main_Category_NAME: String = "main_category_name"
        let Color_ID2: String = "color_id"
        let Color_ID3: String = "color_id"
        let Color_Name: String = "color_name"
        let Color_Code: String = "color_code"
        let NOOFShots: String = "no_of_shots"
        let DrillTypeID: String = "drillTypeid"
        let Scorecard_desc: String = "Scorecard_desc"
        let CreateduserId: String = "createdByUserId"
        
        if (resultSet != nil)
        {
            
            while resultSet?.next() == true
            {
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj.setValue(resultSet!.string(forColumn: Drill_ID), forKey: "Drill_ID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Title), forKey: "Drill_Title")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Short_DESC), forKey: "Drill_Short_DESC")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Long_DESC), forKey: "Drill_Long_DESC")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Est_time), forKey: "Drill_Est_time")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Equity), forKey: "Drill_Equity")
                DicObj.setValue(resultSet!.string(forColumn: Drill_CatID), forKey: "Drill_CatID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Difficulty_ID), forKey: "Drill_Difficulty_ID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_FocusID), forKey: "Drill_FocusID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_ShotID), forKey: "Drill_ShotID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_TrainingID), forKey: "Drill_TrainingID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_PurposeID), forKey: "Drill_PurposeID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_SituationID), forKey: "Drill_SituationID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_MetrixID), forKey: "Drill_MetrixID")
                DicObj.setValue(resultSet!.string(forColumn: CatID), forKey: "CatID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Package_ID), forKey: "Drill_Package_ID")
                DicObj.setValue(resultSet!.string(forColumn: Cat_Name), forKey: "Cat_Name")
                DicObj.setValue(resultSet!.string(forColumn: Color_ID), forKey: "Color_ID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Package_ID1), forKey: "Drill_Package_ID1")
                DicObj.setValue(resultSet!.string(forColumn: Main_Category_ID), forKey: "Main_Category_ID")
                DicObj.setValue(resultSet!.string(forColumn: Color_ID1), forKey: "Color_ID1")
                DicObj.setValue(resultSet!.string(forColumn: Package_Name), forKey: "Package_Name")
                DicObj.setValue(resultSet!.string(forColumn: Main_Category_ID1), forKey: "Main_Category_ID1")
                DicObj.setValue(resultSet!.string(forColumn: Main_Category_NAME), forKey: "Main_Category_NAME")
                DicObj.setValue(resultSet!.string(forColumn: Color_ID2), forKey: "Color_ID2")
                DicObj.setValue(resultSet!.string(forColumn: Color_ID3), forKey: "Color_ID3")
                DicObj.setValue(resultSet!.string(forColumn: Color_Name), forKey: "Color_Name")
                DicObj.setValue(resultSet!.string(forColumn: Color_Code), forKey: "Color_Code")
                DicObj.setValue(resultSet!.string(forColumn: NOOFShots), forKey: "NoOfShots")
                DicObj.setValue(resultSet!.string(forColumn: DrillTypeID), forKey: "DrillTypeID")
                DicObj.setValue(resultSet!.string(forColumn: Scorecard_desc), forKey: "Scorecard_desc")
                DicObj.setValue(resultSet!.string(forColumn: CreateduserId), forKey: "createduserId")
                DicObj.setValue(resultSet!.string(forColumn: "short_label"), forKey: "short_label")
                drill_array.add(DicObj)
            }
            
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        
        return drill_array
    }
    
    func pre_ALL_DRILL_DATA(_ All_Drill: NSMutableArray,cat_id : String,main_cat_id : String)
    {
        
        let userid = UserDefaults.standard.string(forKey: "UserId")!
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        let querySQL = "SELECT * FROM Drill_Info di, Drill_category_master dcm, Drill_package dp, Drill_main_category_master dmcm, Drill_color_master dcolm,Purpose_type_master pm,focus_Master fm WHERE di.category_id=dcm.category_id AND dp.drill_package_id=dcm.drill_package_id AND dmcm.main_category_id=dp.main_category_id AND dcolm.color_id=dp.color_id AND pm.purpose_type_id =  di.purpose_type_id  AND fm.focus_type_id =  di.focus_type_id AND di.CreatedbyuserId = \(userid) AND dcm.category_id = \(cat_id) AND dmcm.main_category_id = \(main_cat_id) order by di.drill_id DESC"
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        let Drill_ID: String = "drill_id"
        let Drill_Title: String = "title"
        let Drill_Short_DESC: String = "abstract_description"
        let Drill_Long_DESC: String = "long_description"
        let Drill_Est_time: String = "estimat_time"
        let Drill_Equity: String = "hundred_percent_equi_value"
        let Drill_CatID: String = "category_id"
        let Drill_Difficulty_ID: String = "diffculty_type_id"
        let Drill_FocusID: String = "focus_type_name"
        let Drill_ShotID: String = "shot_type_id"
        let Drill_TrainingID: String = "traning_type_id"
        let Drill_PurposeID: String = "purpose_type_name"
        let Drill_SituationID: String = "situation_type_id"
        let Drill_MetrixID: String = "metrix_id"

        let CatID: String = "category_id"
        let Drill_Package_ID: String = "drill_package_id"
        let Cat_Name: String = "category_name"
        let Color_ID: String = "color_id"
        let Drill_Package_ID1: String = "drill_package_id"
        let Main_Category_ID: String = "main_category_id"
        let Color_ID1: String = "color_id"
        let Package_Name: String = "package_name"
        let Main_Category_ID1: String = "main_category_id"
        let Main_Category_NAME: String = "main_category_name"
        let Color_ID2: String = "color_id"
        let Color_ID3: String = "color_id"
        let Color_Name: String = "color_name"
        let Color_Code: String = "color_code"
        let NOOFShots: String = "hundred_percent_equi_value"
        let DrillTypeID: String = "drillTypeid"
        let Scorecard_desc: String = "Scorecard_desc"

        if (resultSet != nil)
        {
            
            while resultSet?.next() == true
            {
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj.setValue(resultSet!.string(forColumn: Drill_ID), forKey: "Drill_ID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Title), forKey: "Drill_Title")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Short_DESC), forKey: "Drill_Short_DESC")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Long_DESC), forKey: "Drill_Long_DESC")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Est_time), forKey: "Drill_Est_time")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Equity), forKey: "Drill_Equity")
                DicObj.setValue(resultSet!.string(forColumn: Drill_CatID), forKey: "Drill_CatID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Difficulty_ID), forKey: "Drill_Difficulty_ID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_FocusID), forKey: "Drill_FocusID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_ShotID), forKey: "Drill_ShotID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_TrainingID), forKey: "Drill_TrainingID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_PurposeID), forKey: "Drill_PurposeID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_SituationID), forKey: "Drill_SituationID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_MetrixID), forKey: "Drill_MetrixID")
                DicObj.setValue(resultSet!.string(forColumn: CatID), forKey: "CatID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Package_ID), forKey: "Drill_Package_ID")
                DicObj.setValue(resultSet!.string(forColumn: Cat_Name), forKey: "Cat_Name")
                DicObj.setValue(resultSet!.string(forColumn: Color_ID), forKey: "Color_ID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Package_ID1), forKey: "Drill_Package_ID1")
                DicObj.setValue(resultSet!.string(forColumn: Main_Category_ID), forKey: "Main_Category_ID")
                DicObj.setValue(resultSet!.string(forColumn: Color_ID1), forKey: "Color_ID1")
                DicObj.setValue(resultSet!.string(forColumn: Package_Name), forKey: "Package_Name")
                DicObj.setValue(resultSet!.string(forColumn: Main_Category_ID1), forKey: "Main_Category_ID1")
                DicObj.setValue(resultSet!.string(forColumn: Main_Category_NAME), forKey: "Main_Category_NAME")
                DicObj.setValue(resultSet!.string(forColumn: Color_ID2), forKey: "Color_ID2")
                DicObj.setValue(resultSet!.string(forColumn: Color_ID3), forKey: "Color_ID3")
                DicObj.setValue(resultSet!.string(forColumn: Color_Name), forKey: "Color_Name")
                DicObj.setValue(resultSet!.string(forColumn: Color_Code), forKey: "Color_Code")
                DicObj.setValue(resultSet!.string(forColumn: NOOFShots), forKey: "NoOfShots")
                DicObj.setValue(resultSet!.string(forColumn: DrillTypeID), forKey: "DrillTypeID")
                DicObj.setValue(resultSet!.string(forColumn: Scorecard_desc), forKey: "Scorecard_desc")
                
                All_Drill.add(DicObj)
            }

        }
         // sharedInstance.database?.commit()

        //  sharedInstance.database!.close()
    }
    
    
    
    func SINGLE_DRILL_DATA(_ Drill_Id: NSString) -> NSMutableArray
    {
        print(Drill_Id)
        
        let All_Drill : NSMutableArray = NSMutableArray()
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        let querySQL = "SELECT * FROM Drill_Info di, Drill_category_master dcm, Drill_package dp, Drill_main_category_master dmcm, Drill_color_master dcolm,Purpose_type_master pm WHERE di.drill_id = \(Drill_Id) AND di.category_id=dcm.category_id AND dp.drill_package_id=dcm.drill_package_id AND dmcm.main_category_id=dp.main_category_id AND dcolm.color_id=dp.color_id  AND di.focus_type_id=pm.focus_type_id order by di.drill_id DESC"
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        let Drill_ID: String = "drill_id"
        let Drill_Title: String = "title"
        let Drill_Short_DESC: String = "abstract_description"
        let Drill_Long_DESC: String = "long_description"
        let Drill_Est_time: String = "estimat_time"
        let Drill_Equity: String = "hundred_percent_equi_value"
        let Drill_CatID: String = "category_id"
        let Drill_Difficulty_ID: String = "diffculty_type_id"
        let Drill_FocusID: String = "focus_type_name"
        let Drill_ShotID: String = "shot_type_id"
        let Drill_TrainingID: String = "traning_type_id"
        let Drill_PurposeID: String = "purpose_type_id"
        let Drill_SituationID: String = "situation_type_id"
        let Drill_MetrixID: String = "metrix_id"
        let CatID: String = "category_id"
        let Drill_Package_ID: String = "drill_package_id"
        let Cat_Name: String = "category_name"
        let Color_ID: String = "color_id"
        let Drill_Package_ID1: String = "drill_package_id"
        let Main_Category_ID: String = "main_category_id"
        let Color_ID1: String = "color_id"
        let Package_Name: String = "package_name"
        let Main_Category_ID1: String = "main_category_id"
        let Main_Category_NAME: String = "main_category_name"
        let Color_ID2: String = "color_id"
        let Color_ID3: String = "color_id"
        let Color_Name: String = "color_name"
        let Color_Code: String = "color_code"
        let NOOFShots: String = "hundred_percent_equi_value"
        let DrillTypeID: String = "drillTypeid"
        let Scorecard_desc: String = "Scorecard_desc"
        
        
        
        if (resultSet != nil) {
            
            while resultSet?.next() == true
            {
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj.setValue(resultSet!.string(forColumn: Drill_ID), forKey: "Drill_ID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Title), forKey: "Drill_Title")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Short_DESC), forKey: "Drill_Short_DESC")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Long_DESC), forKey: "Drill_Long_DESC")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Est_time), forKey: "Drill_Est_time")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Equity), forKey: "Drill_Equity")
                DicObj.setValue(resultSet!.string(forColumn: Drill_CatID), forKey: "Drill_CatID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Difficulty_ID), forKey: "Drill_Difficulty_ID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_FocusID), forKey: "Drill_FocusID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_ShotID), forKey: "Drill_ShotID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_TrainingID), forKey: "Drill_TrainingID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_PurposeID), forKey: "Drill_PurposeID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_SituationID), forKey: "Drill_SituationID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_MetrixID), forKey: "Drill_MetrixID")
                DicObj.setValue(resultSet!.string(forColumn: CatID), forKey: "CatID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Package_ID), forKey: "Drill_Package_ID")
                DicObj.setValue(resultSet!.string(forColumn: Cat_Name), forKey: "Cat_Name")
                DicObj.setValue(resultSet!.string(forColumn: Color_ID), forKey: "Color_ID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Package_ID1), forKey: "Drill_Package_ID1")
                DicObj.setValue(resultSet!.string(forColumn: Main_Category_ID), forKey: "Main_Category_ID")
                DicObj.setValue(resultSet!.string(forColumn: Color_ID1), forKey: "Color_ID1")
                DicObj.setValue(resultSet!.string(forColumn: Package_Name), forKey: "Package_Name")
                DicObj.setValue(resultSet!.string(forColumn: Main_Category_ID1), forKey: "Main_Category_ID1")
                DicObj.setValue(resultSet!.string(forColumn: Main_Category_NAME), forKey: "Main_Category_NAME")
                DicObj.setValue(resultSet!.string(forColumn: Color_ID2), forKey: "Color_ID2")
                DicObj.setValue(resultSet!.string(forColumn: Color_ID3), forKey: "Color_ID3")
                DicObj.setValue(resultSet!.string(forColumn: Color_Name), forKey: "Color_Name")
                DicObj.setValue(resultSet!.string(forColumn: Color_Code), forKey: "Color_Code")
                DicObj.setValue(resultSet!.string(forColumn: NOOFShots), forKey: "NoOfShots")
                DicObj.setValue(resultSet!.string(forColumn: DrillTypeID), forKey: "DrillTypeID")
                DicObj.setValue(resultSet!.string(forColumn: Scorecard_desc), forKey: "Scorecard_desc")
                
                All_Drill.add(DicObj)
            }
            
        }
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
        
        return All_Drill
    }
    
    
    func Insert_Drill_Exp_Value(_ DrillExpValue: NSMutableArray)
    {
        print(" \(DrillExpValue)")
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        for i in 0 ..< DrillExpValue.count 
        {
            
            
            let drillID  = (DrillExpValue[i] as AnyObject).value(forKey: "drillId")
            let drillExpactedmetrixId = (DrillExpValue[i] as AnyObject).value(forKey: "drillExpactedmetrixId")
            let drillExpactedMetrixValue = (DrillExpValue[i] as AnyObject).value(forKey: "drillExpactedMetrixValue")
            let drillExpactedMetrixRow = (DrillExpValue[i] as AnyObject).value(forKey: "drillExpactedMetrixRow")
            let drillExpactedMetrixCol = (DrillExpValue[i] as AnyObject).value(forKey: "drillExpactedMetrixCol")
            
 
            sharedInstanceQueue.databaseQueue!.inDeferredTransaction { database, rollback in
                do
                {
                    let querySQL = "INSERT INTO Drill_matrix_expected_value(drill_matrix_exp_val_id, drill_id, row_no, col_no, minimumValue) VALUES ('\(drillExpactedmetrixId!)', '\(drillID!)', '\(drillExpactedMetrixRow!)', '\(drillExpactedMetrixCol!)', '\(drillExpactedMetrixValue!)')";
                    print("query : \(querySQL)")
                    
                    var flag: Bool
                    
                    flag = try database!.executeStatements(querySQL, withResultBlock: nil)
                    
                    print("flag : \(flag)")
                }
                catch
                {
                    rollback!.pointee = true
                    print(error)
                }
            }
        }
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
    }
    
    
    
    
    func Insert_Drill_label(_ DrillLabel: NSMutableArray)
    {
        print(" \(DrillLabel)")
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        for i in 0 ..< DrillLabel.count 
        {
            
            
            let drill_info = DrillLabel[i] as! NSDictionary
            
            let drillId  = (DrillLabel[i] as AnyObject).value(forKey: "drillId")
            let drillMatrixLabelsId = (DrillLabel[i] as AnyObject).value(forKey: "drillMatrixLabelsId")
            let rowPos = (DrillLabel[i] as AnyObject).value(forKey: "rowPos")
            let value = (DrillLabel[i] as AnyObject).value(forKey: "value")
            let coulmnPos = (DrillLabel[i] as AnyObject).value(forKey: "coulmnPos")
            
//            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Drill_matrix_expected_label(id, drill_id, row_label, col_lable, value) VALUES (:drillMatrixLabelsId, :drillId, :rowPos, :coulmnPos, :value)", withParameterDictionary : drill_info as! [AnyHashable: Any]);
            
            
            sharedInstanceQueue.databaseQueue!.inDeferredTransaction { database, rollback in
                do
                {
                    let querySQL = "INSERT INTO Drill_matrix_expected_label(id, drill_id, row_label, col_lable, value) VALUES ('\(drillMatrixLabelsId!)', '\(drillId!)', '\(rowPos!)', '\(coulmnPos!)', '\(value!)')";
                    print("query : \(querySQL)")

                    let flag: Bool
                    flag =  try database!.executeUpdate(querySQL, withArgumentsIn: nil)
                    print("flag : \(flag)")

                }
                catch
                {
                    rollback!.pointee = true
                    print(error)
                }
            }
            
            
            
        }
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
    }
    
    
    func findisteacher(_ uid:String)->String
    {
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        let querySQL = "select teacherId from teacherInfo where userId=\(uid)"
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        var tid=""
        if (resultSet != nil) {
            while resultSet?.next() == true
            {
               tid = resultSet!.string(forColumn: "teacherId") as String
            }
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        
        return tid
    }
    
    func Matrix3(_ MATID : NSString, MatArray : NSMutableArray){
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

        let querySQL = "select * from Matrix_master where metrix_id = \(MATID)"
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        let matid: String = "metrix_id"
        let matType: String = "type"
        let matRow: String = "row"
        let matCol: String = "col"
        if (resultSet != nil) {
            while resultSet?.next() == true {
                
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj .setValue(resultSet!.string(forColumn: matid), forKey: "matid")
                DicObj .setValue(resultSet!.string(forColumn: matType), forKey: "matType")
                DicObj .setValue(resultSet!.string(forColumn: matRow), forKey: "matRow")
                DicObj .setValue(resultSet!.string(forColumn: matCol), forKey: "matCol")
                MatArray.add(DicObj)
            }
        }
         // sharedInstance.database?.commit()

        //  sharedInstance.database!.close()
    }
    
    
    func Drill_Images(_ DrillId : NSString)->NSMutableArray
    {
        
        let ImageArray : NSMutableArray = NSMutableArray()
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

    
        let querySQL = "select * from Illustration_media where drill_id = \(DrillId)"
        print(querySQL)
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
       
        let mediaID: String = "media_id"
        let Mediapath: String = "media_path"
        let DrillId: String = "drill_id"
       
        if (resultSet != nil) {
            while resultSet?.next() == true {
                
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj .setValue(resultSet!.string(forColumn: mediaID), forKey: "mediaID")
                DicObj .setValue(resultSet!.string(forColumn: Mediapath), forKey: "Mediapath")
                DicObj .setValue(resultSet!.string(forColumn: DrillId), forKey: "DrillId")
                ImageArray.add(DicObj)
            }
            
        }
         // sharedInstance.database?.commit()

        //  sharedInstance.database!.close()
        return ImageArray
    }
    
    
    
    
    
    func getmaincategory_bydrillid(_ drillid:String)->String?
    {
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        let sql = "select dmcm.main_category_id from Drill_Info di inner join Drill_category_master dcm on di.category_id=dcm.category_id inner join Drill_package dp on dp.drill_package_id=dcm.drill_package_id inner join Drill_main_category_master dmcm on dmcm.main_category_id=dp.main_category_id where di.drill_id = \(drillid)"
        
        
        var maincat_id = ""
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(sql, withArgumentsIn: nil)
        
        if (resultSet != nil) {
            
            while resultSet?.next() == true
            {
                
               maincat_id = resultSet!.string(forColumn: "main_category_id")
            }
        }
        
        
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        return maincat_id
    }
    
    
    
    func FetchDrillOnCategory(_ CATID : String, MainCATID : String)-> NSMutableArray
    {
        var AllDrillData : NSMutableArray = NSMutableArray()
        
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        let querySQL = "SELECT * FROM Drill_Info di, Drill_category_master dcm, Drill_package dp, Drill_main_category_master dmcm, Drill_color_master dcolm WHERE di.category_id = \(CATID) AND di.category_id=dcm.category_id AND dp.drill_package_id=dcm.drill_package_id AND dmcm.main_category_id=dp.main_category_id AND dcolm.color_id=dp.color_id order by di.drill_id DESC"
          print("SQLquery : \(querySQL))")
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        //  print("ResultSet : \(resultSet))")
        
        let Drill_ID: String = "drill_id"
        let Drill_Title: String = "title"
        let Drill_Short_DESC: String = "abstract_description"
        let Drill_Long_DESC: String = "long_description"
        let Drill_Est_time: String = "estimat_time"
        let Drill_Equity: String = "hundred_percent_equi_value"
        let Drill_CatID: String = "category_id"
        let Drill_Difficulty_ID: String = "diffculty_type_id"
        let Drill_FocusID: String = "focus_type_id"
        let Drill_ShotID: String = "shot_type_id"
        let Drill_TrainingID: String = "traning_type_id"
        let Drill_PurposeID: String = "purpose_type_id"
        let Drill_SituationID: String = "situation_type_id"
        let Drill_MetrixID: String = "metrix_id"
        
        let CatID: String = "category_id"
        let Drill_Package_ID: String = "drill_package_id"
        let Cat_Name: String = "category_name"
        let Color_ID: String = "color_id"
        let Drill_Package_ID1: String = "drill_package_id"
        let Main_Category_ID: String = "main_category_id"
        let Color_ID1: String = "color_id"
        let Package_Name: String = "package_name"
        let Main_Category_ID1: String = "main_category_id"
        let Main_Category_NAME: String = "main_category_name"
        let Color_ID2: String = "color_id"
        let Color_ID3: String = "color_id"
        let Color_Name: String = "color_name"
        let Color_Code: String = "color_code"
        let NOOFShots: String = "hundred_percent_equi_value"
        let DrillTypeID: String = "drillTypeid"
        let Scorecard_desc: String = "Scorecard_desc"
        
        
        
        if (resultSet != nil) {
            
            while resultSet?.next() == true
            {
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj.setValue(resultSet!.string(forColumn: Drill_ID), forKey: "Drill_ID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Title), forKey: "Drill_Title")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Short_DESC), forKey: "Drill_Short_DESC")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Long_DESC), forKey: "Drill_Long_DESC")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Est_time), forKey: "Drill_Est_time")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Equity), forKey: "Drill_Equity")
                DicObj.setValue(resultSet!.string(forColumn: Drill_CatID), forKey: "Drill_CatID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Difficulty_ID), forKey: "Drill_Difficulty_ID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_FocusID), forKey: "Drill_FocusID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_ShotID), forKey: "Drill_ShotID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_TrainingID), forKey: "Drill_TrainingID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_PurposeID), forKey: "Drill_PurposeID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_SituationID), forKey: "Drill_SituationID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_MetrixID), forKey: "Drill_MetrixID")
                DicObj.setValue(resultSet!.string(forColumn: CatID), forKey: "CatID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Package_ID), forKey: "Drill_Package_ID")
                DicObj.setValue(resultSet!.string(forColumn: Cat_Name), forKey: "Cat_Name")
                DicObj.setValue(resultSet!.string(forColumn: Color_ID), forKey: "Color_ID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Package_ID1), forKey: "Drill_Package_ID1")
                DicObj.setValue(resultSet!.string(forColumn: Main_Category_ID), forKey: "Main_Category_ID")
                DicObj.setValue(resultSet!.string(forColumn: Color_ID1), forKey: "Color_ID1")
                DicObj.setValue(resultSet!.string(forColumn: Package_Name), forKey: "Package_Name")
                DicObj.setValue(resultSet!.string(forColumn: Main_Category_ID1), forKey: "Main_Category_ID1")
                DicObj.setValue(resultSet!.string(forColumn: Main_Category_NAME), forKey: "Main_Category_NAME")
                DicObj.setValue(resultSet!.string(forColumn: Color_ID2), forKey: "Color_ID2")
                DicObj.setValue(resultSet!.string(forColumn: Color_ID3), forKey: "Color_ID3")
                DicObj.setValue(resultSet!.string(forColumn: Color_Name), forKey: "Color_Name")
                DicObj.setValue(resultSet!.string(forColumn: Color_Code), forKey: "Color_Code")
                DicObj.setValue(resultSet!.string(forColumn: NOOFShots), forKey: "NoOfShots")
                DicObj.setValue(resultSet!.string(forColumn: DrillTypeID), forKey: "DrillTypeID")
                DicObj.setValue(resultSet!.string(forColumn: Scorecard_desc), forKey: "Scorecard_desc")
                
                  print("DictionaryObject : \(DicObj))")
                
                AllDrillData.add(DicObj)
            }
            // print("All_Drill : \(All_Drill))")
            
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        
        
        return AllDrillData;
    }
    
    
    
    /*        let query2 = "update Result_Metrix set result_val = \(Int(total_result_value)) where drillResultMetrixId = \(result_mat_id)"
     */
    
    

    func Insert_Image_Illutrationmedia(_ DrillImages: NSMutableArray, DrillId:String,action:String)
        {
            
            
        print(DrillImages)
        print(DrillId)
            sharedInstance.database!.open()
            // sharedInstance.database?.beginTransaction()
            
          var querySQL = ""
         
            
            var querySQL1 = "DELETE FROM Illustration_media where drill_id =('\(DrillId)')"
           
            
            let  xx : Bool
            xx =  sharedInstance.database!.executeUpdate(querySQL1, withArgumentsIn: nil)
            
            print("query : \(xx)")
            
            
            
            for index in 0 ..< DrillImages.count 
            {
                
            
                var imagename = ""
                
                if action == "drillbase"
                {
                    imagename = (DrillImages.object(at: index) as AnyObject).value(forKey: "mediaName") as! String
                }
                    
                else
                {
                    imagename = DrillImages.object(at: index) as! String
                }
                
                querySQL = "INSERT INTO Illustration_media(media_path, drill_id) VALUES ('\(imagename)', '\(DrillId)')";
                print("query : \(querySQL)")

                let flag: Bool
            
                flag =  database!.executeStatements(querySQL)
        
                print("flag : \(flag)")
                
                
            }
             // sharedInstance.database?.commit()
            
            //  sharedInstance.database!.close()
        
    }
    
    
    func Insert_Illutrationmedia1(_ DrillImages: NSMutableArray, DrillId:String)
    {
        
        
        
        print("DrillImages : \(DrillImages)")
        print("DrillId : \(DrillId)")
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        for index in 0 ..< DrillImages.count 
        {
            let Imagename = DrillImages.object(at: index) as? String
            let querySQL = "INSERT INTO Illustration_media(media_path, drill_id) VALUES ('\(Imagename!)', '\(DrillId)')";
            print("query : \(querySQL)")
            
            let flag: Bool
            
            flag =  database!.executeStatements(querySQL)
            
            print("flag : \(flag)")
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        
    }
    
 
    func Insert_Illutrationmedia(_ DrillImages: NSMutableArray, DrillId:String)
    {
        
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

        print("DrillImages : \(DrillImages)")
        print("DrillId : \(DrillId)")
        
        
        
        for index in 0 ..< (DrillImages.object(at: 0) as AnyObject).count
        {
            
            let Imagename = ((DrillImages.object(at: 0) as AnyObject).object(at: index) as AnyObject).value(forKey: "mediaName")
            let querySQL = "INSERT INTO Illustration_media(media_path, drill_id) VALUES ('\(Imagename!)', '\(DrillId)')";
            print("query : \(querySQL)")
            
            let flag: Bool
            
            flag =  database!.executeStatements(querySQL)
            
            print("flag : \(flag)")
            
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()

        
    }

  
    
    func Database_PlanBreakData(_ PlanBreakArray: NSMutableArray)  {
        
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

        let querySQL = "select * from PlanBreak"
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        let PlanBreak_ID: String = "PlanBreakID"
        let PlanBreaktimeMili: String = "PlanBreakTimeMili"
        
        
        if (resultSet != nil) {
            while resultSet?.next() == true
            {
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj .setValue(resultSet!.string(forColumn: PlanBreak_ID), forKey: "PlanBreak_ID")
                DicObj .setValue(resultSet!.string(forColumn: PlanBreaktimeMili), forKey: "PlanBreaktimeMili")
                
                PlanBreakArray.add(DicObj)
            }
            
        }
         // sharedInstance.database?.commit()

        //  sharedInstance.database!.close()
    }
    func insertplasns(_ plasdetails :NSMutableArray)
    {
        
        var querySQL = ""
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

        
        for i in 0 ..< plasdetails.count
        {
            
            var catid:String = String()
            var catname:String = String()
            var Editable:String = String()
            var userid:String = String()

        
            catid  = (plasdetails[i] as AnyObject).value(forKey: "planCategoryId") as! String
            catname = (plasdetails[i] as AnyObject).value(forKey: "CategoryName") as! String
            Editable = (plasdetails[i] as AnyObject).value(forKey: "isEdtable") as! String
            userid = (plasdetails[i] as AnyObject).value(forKey: "userId") as! String
        
           querySQL = "INSERT INTO plan_category_master(plan_category_id, category_name, isEditable,userId) VALUES ('\(catid)', '\(catname)', '\(Editable)', '\(userid)')";
            print("query : \(querySQL)")
        
            let flag: Bool
        
            flag =  database!.executeStatements(querySQL)
        
            print("flag : \(flag)")
            
        }
        
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()

    }

    func Database_PlanCategory(_ PurposeType: NSMutableArray)
    {
        
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        let querySQL = "select * from plan_category_master where category_name != 'default' and category_name != 'teacherPlan' "
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        let CategoryId: String = "plan_category_id"
        let CategoryName: String = "category_name"
        let editable: String = "isEditable"
        let userId: String = "userId"
        if (resultSet != nil) {
            while resultSet?.next() == true {
                print("CategoryId : \(resultSet!.string(forColumn: CategoryId))")
                print("CategoryName : \(resultSet!.string(forColumn: CategoryName))")
                
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj .setValue(resultSet!.string(forColumn: CategoryId), forKey: "CategoryId")
                DicObj .setValue(resultSet!.string(forColumn: CategoryName), forKey: "CategoryName")
                DicObj .setValue(resultSet!.string(forColumn: editable), forKey: "editable")
                DicObj .setValue(resultSet!.string(forColumn: userId), forKey: "userId")

                PurposeType.add(DicObj)
            }
            
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        
    }
    
    func Insert_PLAN(_ PlanID: String, PlanCatID:String, PlanTitle: String, planTypeId:String, Plandesc:String,inqueue:String,repetation:String,completedRepetation:String,isforcefully:String)
    {
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

//        let querySQL = "INSERT INTO Plan(plan_id,plan_category_id,plan_title,planTypeId, Plan_Desc) VALUES ('\(PlanID)', '\(PlanCatID)', '\(PlanTitle)', '\(planTypeId)', '\(Plandesc)')";
//        print("query : \(querySQL)")
        
       let DrillDetailInfo = ["plan_id":PlanID,"plan_category_id":PlanCatID,"plan_title":PlanTitle,"planTypeId":planTypeId,"Plan_Desc":Plandesc,"inqueue":inqueue,"repetation":repetation,"completedRepetation":completedRepetation,"isforcefully":isforcefully] as NSDictionary
        
        
         let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Plan(plan_id, plan_category_id, plan_title, planTypeId, Plan_Desc,inqueue,repetation,completedRepetation,isforcefully) VALUES (:plan_id, :plan_category_id, :plan_title, :planTypeId, :Plan_Desc,:inqueue,:repetation,:completedRepetation,:isforcefully)", withParameterDictionary : DrillDetailInfo as! [AnyHashable: Any]);
        
        
        
        
//        let flag: Bool
//        
//        flag =  database!.executeStatements(querySQL)
        
        print("flag : \(isInserted)")
         // sharedInstance.database?.commit()

        //  sharedInstance.database!.close()
        
    }
    
    
    
    func Insert_Plan_Transaction(_ Plan_Drill_Transaction: NSMutableArray)
    {
        
        
        
        print("flag : \(Plan_Drill_Transaction)")

        
        var TransId : NSString = NSString()
        var DrillID : NSString = NSString()
        var PlanID : NSString = NSString()
        var seqNo : NSString = NSString()
        var breakID : NSString = NSString()
        var dayNo : NSString = NSString()

    
       
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

        for index1 in 0 ..< Plan_Drill_Transaction.count 
        {

            let ff = (Plan_Drill_Transaction[index1] as AnyObject).value(forKey: "drillPlanTransactionId") as! Int
            TransId =  NSString(format: "%d",ff)
            
            let aa = (Plan_Drill_Transaction[index1] as AnyObject).value(forKey: "planId") as! Int
            
            PlanID = NSString(format: "%d",aa)
            
            let dIDs = (Plan_Drill_Transaction[index1] as AnyObject).value(forKey: "drillId") as! String
            
            //  let dID =  dIDs as! NSNumber
            
            DrillID = dIDs as NSString
            //Double(((item as! NSDictionary).value(forKey:"dificulty") as AnyObject) as! NSNumber)
            
            if let result_number = ((Plan_Drill_Transaction[index1] as AnyObject) as! NSDictionary).value(forKey: "sequenceNo") as? NSNumber
            {
                seqNo = "\(result_number)" as NSString
            }
            
            // let day =  ((Plan_Drill_Transaction[index1] as AnyObject) as! NSDictionary).value(forKey: "dayNo")
            
            dayNo = ((Plan_Drill_Transaction[index1]) as! NSDictionary).value(forKey: "dayNo") as! NSString

           
            if ((Plan_Drill_Transaction[index1] as AnyObject).value(forKey: "planBreakId")! as AnyObject).isKind(of: NSString.self)
            {
                 let xyz : String =  (Plan_Drill_Transaction.object(at: index1) as AnyObject).value(forKey: "planBreakId") as! String
                if(xyz.isEmpty)
                {
                    breakID = " "
                }else{
                    
                   // let abc = ((Plan_Drill_Transaction[index1] as AnyObject) as! NSDictionary).value(forKey: "planBreakId") as? String
                    breakID  = ((Plan_Drill_Transaction[index1]) as! NSDictionary).value(forKey: "planBreakId") as! NSString //  NSString(format: "%d",abc!)
                    
                }
            }
            else if ((Plan_Drill_Transaction.object(at: index1) as AnyObject).value(forKey: "planBreakId")! as AnyObject).isKind(of: NSNumber.self)
            {
                
                //let xyz =  ((Plan_Drill_Transaction[index1] as AnyObject) as! NSDictionary).value(forKey: "planBreakId") as? String
               // breakID = NSString(format: "%d",xyz!)
                breakID  = ((Plan_Drill_Transaction[index1]) as! NSDictionary).value(forKey: "planBreakId") as! NSString //  NSString(format: "%d",abc!)

            }
            
           
            let querySQL = "INSERT INTO Drill_plan_transaction (plan_transaction_id, drill_id, plan_id, sequenceNo, planBreakId, dayNo) VALUES ('\(TransId)', '\(DrillID)', '\(PlanID)', '\(seqNo)',  '\(breakID)', '\(dayNo)')";
                print("query : \(querySQL)")
        
                let flag: Bool
        
                flag =  database!.executeStatements(querySQL)
                print("flag : \(flag)")
        }
        
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()

  }
    
    func Insert_Plan_Transaction2(_ Plan_Drill_Transaction: NSMutableArray)
    {
        
        print("flag : \(Plan_Drill_Transaction)")
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        var TransId : NSString = NSString()
        var DrillID : NSString = NSString()
        var PlanID : NSString = NSString()
        var seqNo : NSString = NSString()
        var breakID : NSString = NSString()
        var dayNo : NSString = NSString()
        
        for index1 in 0 ..< Plan_Drill_Transaction.count
        {
        let    TransId = (Plan_Drill_Transaction.object(at: index1) as AnyObject).value(forKey: "drillPlanTransactionId") as! Int
        let    DrillID =  (Plan_Drill_Transaction.object(at: index1) as AnyObject).value(forKey: "drillId") as! String
        let    PlanID =  (Plan_Drill_Transaction.object(at: index1) as AnyObject).value(forKey: "planId") as! String
        let    breakID = (Plan_Drill_Transaction.object(at: index1) as AnyObject).value(forKey: "planBreakId") as! String
            
        let    seqNo = (Plan_Drill_Transaction.object(at: index1) as AnyObject).value(forKey: "sequenceNo") as! String
            dayNo = (Plan_Drill_Transaction.object(at: index1) as AnyObject).value(forKey: "dayNo") as! NSString
            
            
            
            let querySQL = "INSERT INTO Drill_plan_transaction (plan_transaction_id, drill_id, plan_id, sequenceNo, planBreakId, dayNo ) VALUES ('\(TransId)', '\(DrillID)', '\(PlanID)', '\(seqNo)',  '\(breakID)', '\(dayNo)')";
            print("query : \(querySQL)")
            
            let flag: Bool
            
            flag =  database!.executeStatements(querySQL)
            print("flag : \(flag)")
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
    }
    
    
    
    
    func Insert_Plan_Transaction1(_ Plan_Drill_Transaction: NSMutableArray)
    {
        print("flag : \(Plan_Drill_Transaction)")
        
        
        var TransId : NSString = NSString()
        var DrillID : NSString = NSString()
        var PlanID : NSString = NSString()
        var seqNo : NSString = NSString()
        var breakID : NSString = NSString()
        var dayNo : NSString = NSString()
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

        for index1 in 0 ..< Plan_Drill_Transaction.count
        {
            
            
            TransId = (Plan_Drill_Transaction.object(at: index1) as AnyObject).value(forKey: "transid") as! NSString
            DrillID = (Plan_Drill_Transaction.object(at: index1) as AnyObject).value(forKey: "DrillID") as! NSString
            PlanID =  (Plan_Drill_Transaction.object(at: index1) as AnyObject).value(forKey: "PlanID") as! NSString
            breakID = (Plan_Drill_Transaction.object(at: index1) as AnyObject).value(forKey: "BreakId") as! NSString
    
            seqNo = (Plan_Drill_Transaction.object(at: index1) as AnyObject).value(forKey: "SequenceID") as! NSString
            dayNo = (Plan_Drill_Transaction.object(at: index1) as AnyObject).value(forKey: "Day") as! NSString
            
            let querySQL = "INSERT INTO Drill_plan_transaction (plan_transaction_id, drill_id, plan_id, sequenceNo, planBreakId, dayNo ) VALUES ('\(TransId)', '\(DrillID)', '\(PlanID)', '\(seqNo)',  '\(breakID)', '\(dayNo)')";
            print("query : \(querySQL)")
            
            let flag: Bool
            
            flag =  database!.executeStatements(querySQL)
            print("flag : \(flag)")
            
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()

    }
    
    
   
    func insert_prem_subcat(_ scatarr : NSArray)
    
    {
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        let dbpath = documentsPath + "/"+"golf.sqlite"
       var db: OpaquePointer? = nil
        
        
        for i in 0 ..< scatarr.count
            {
        
        let dic = scatarr[i] as! NSDictionary
        //
            let pid = dic["planSubCategoryId"] as! String
            let cname = dic["CategoryName"] as! String
            let ptid  = dic["palnMainCategoryId"] as! String
        
        
        if sqlite3_open(dbpath, &db) == SQLITE_OK
        {
            let  Query = String(format: "insert into pre_plan_sub_cat (planSubCategoryId,CategoryName,palnMainCategoryId) values ('%@','%@','%@')", pid,cname,ptid)
            var statement: OpaquePointer? = nil;
            if sqlite3_prepare_v2(db, Query, -1, &statement, nil) == SQLITE_OK
            {
                sqlite3_step(statement)
            }
            
            else
            {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error preparing insert: \(errmsg)")
            }
        }
        sqlite3_close(db)
        }
    
    }
    
    func insert_preuim_plan(_ all_plan : NSArray)
    {
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        let querySQL = "delete FROM pre_plan_main_cat"
        let  xx : Bool
        xx =  sharedInstance.database!.executeUpdate(querySQL, withArgumentsIn: nil)
        print("query : \(xx)")
        
        for i in 0..<all_plan.count
        {
            
            var dic = all_plan[i] as! NSDictionary
            
            let pid = dic["palnMainCategoryId"]
            let cname = dic["CategoryName"] 
            let ptid  = dic["planTypeId"]
            
            let querySQL = "INSERT INTO pre_plan_main_cat (pid, cname, ptid ) VALUES ('\(pid!)', '\(cname!)', '\(ptid!)')";
            print("query : \(querySQL)")
            
            let flag: Bool
            
            flag =  database!.executeStatements(querySQL)
            print("flag : \(flag)")
            
        }
        
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
        
    }
    
    func Insert_PLANInBackground_WS(_ All_Plan_WS: NSMutableArray)
    {
        print("\(All_Plan_WS)")
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        let queryDeleteSQL = "delete from Plan";
        
        database!.executeStatements(queryDeleteSQL)
        
        for i in 0 ..< All_Plan_WS.count
        {
            //let newArray = All_Plan_WS[i] as! NSDictionary
            var newArray : NSMutableDictionary = NSMutableDictionary()
            newArray = All_Plan_WS[i] as! NSMutableDictionary
            
            //  /* Change By Hardik
            
            let PlanID = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "PlanID")
            let PlanCatID =  (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "planCategoryId")
            
            let PlanTitle = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "PlanTitle")
            let PlanTypeId = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "planTypeId")
            
            var isPremium = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "isPremium")
            
            var Plandesc = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "PlanDescription")
            
            let desc = Plandesc as? NSString
            
            if desc?.lowercased.range(of:"'") != nil
            {
                Plandesc = (Plandesc as AnyObject).replacingOccurrences(of: "'", with: "`")
            }
            
            var inqueue = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "inqueue")
            
            var from_student = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "from_student")
            
            if (inqueue == nil)
            {
                inqueue = ""
            }
            
            if (from_student == nil)
            {
                from_student = "0"
            }
            
            if (isPremium == nil)
            {
                isPremium = "0"
            }
            
            var isforcefully = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "isforcefully")
            
            if (isforcefully == nil)
            {
                isforcefully = "0"
            }
            
            var repetation = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "repetation")
            
            if (repetation == nil)
            {
                repetation = "0"
            }
            
            var completedRepetation = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "completedRepetation")
            
            if (completedRepetation == nil)
            {
                completedRepetation = "0"
            }
            
            var planmaincatid = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "planmaincatid")
            
            
            if (planmaincatid == nil)
            {
                planmaincatid = "0"
            }
            
            var plansubcatid = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "plansubcatid")
            
            
            if (plansubcatid == nil)
            {
                plansubcatid = "0"
            }
            
            
            let querySQL = "INSERT OR REPLACE INTO Plan(plan_id, plan_category_id, plan_title, planTypeId,Plan_Desc,planmaincatid,plansubcatid,inqueue,repetation,completedRepetation,isforcefully,isPremium,from_student) VALUES ('\(PlanID!)', '\(PlanCatID!)', '\(PlanTitle!)', '\(PlanTypeId!)', '\(Plandesc!)','\(planmaincatid!)','\(plansubcatid!)', '\(inqueue!)', '\(repetation!)', '\(completedRepetation!)', '\(isforcefully!)','\(isPremium!)','\(from_student!)')";
            print("query : \(querySQL)")
            //
            let flag: Bool
            
            flag =  database!.executeStatements(querySQL)
            
            print("flag : \(flag)")
            // */
            
            
            
            /* Change By Hardik 26/5/17
             
             if let plansubcatid = newArray["plansubcatid"] as? String
             {
             newArray.setValue(plansubcatid, forKey: "plansubcatid")
             }
             else
             {
             newArray.setValue("0", forKey: "plansubcatid")
             }
             
             if let planmaincatid = newArray["planmaincatid"] as? String
             {
             newArray.setValue(planmaincatid, forKey: "planmaincatid")
             }
             else
             {
             newArray.setValue("0", forKey: "planmaincatid")
             }
             
             if let isPremium = newArray["isPremium"] as? String
             {
             newArray.setValue(isPremium, forKey: "isPremium")
             }
             else
             {
             newArray.setValue("0", forKey: "isPremium")
             }
             
             if let from_student1 = newArray["from_student"] as? String
             {
             newArray.setValue(from_student1, forKey: "from_student")
             }
             else
             {
             newArray.setValue("0", forKey: "from_student")
             }
             
             
             newArray.removeObject(forKey: "PlanCatID")
             
             //    let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Plan (plan_id,plan_category_id,plan_title,planTypeId,Plan_Desc,planmaincatid,plansubcatid,inqueue,repetation,completedRepetation,isforcefully,isPremium,from_student) VALUES (:PlanID, :planCategoryId, :PlanTitle, :planTypeId, :PlanDescription, :planmaincatid, :plansubcatid, :inqueue, :repetation, :completedRepetation, :isforcefully, :isPremium, :from_student)", withParameterDictionary : newArray as! [AnyHashable: Any]);
             
             let pIda = newArray.object(forKey:"PlanID")
             //            let pId = pIds[0] as? String
             //            let pIda = Int(pId!)// as? Num
             
             let planCategoryIds = newArray.object(forKey:"planCategoryId") as? NSArray
             let plan_category_id =  planCategoryIds?[0] as? String
             
             let plan_titles = newArray.object(forKey: "PlanTitle") as? NSArray
             let plan_title = plan_titles?[0] as? String
             
             let planTypeIdss = newArray.object(forKey:"planTypeId") as? NSArray
             let planTypeId = planTypeIdss?[0] as? String
             
             let PlanDescriptions = newArray.object(forKey:"PlanDescription") as? NSArray
             let PlanDescription = PlanDescriptions?[0] as? String
             
             let planmaincatid = newArray.value(forKey: "planmaincatid") as? String
             let plansubcatid = newArray.value(forKey: "plansubcatid") as? String
             let inqueue = newArray.value(forKey: "inqueue") as? String
             
             let repetations = newArray.value(forKey: "repetation") as? NSArray
             let repetation = repetations?[0] as? String
             
             let completedRepetations = newArray.object(forKey: "completedRepetation") as? NSArray
             let completedRepetation = completedRepetations?[0] as? String
             
             let isforcefully = newArray.value(forKey: "isforcefully") as?  String
             let isPremium = newArray.value(forKey: "isPremium") as? String
             let from_student = newArray.value(forKey: "from_student") as? String
             
             //hrdik   let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Plan (plan_id,plan_category_id,plan_title,planTypeId,Plan_Desc,planmaincatid,plansubcatid,inqueue,repetation,completedRepetation,isforcefully,isPremium,from_student) VALUES ('\(pId)','\(plan_category_id)','\(plan_title)','\(planTypeId)','\(PlanDescription)','\(planmaincatid)','\(plansubcatid)','\(inqueue)','\(repetation)','\(completedRepetation)','\(isforcefully)','\(isPremium)','\(from_student)')");
             //(?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?,?)
             
             
             let querySQL = "INSERT INTO Plan (plan_id,plan_category_id,plan_title,planTypeId,Plan_Desc,planmaincatid,plansubcatid,inqueue,repetation,completedRepetation,isforcefully,isPremium,from_student) VALUES ('\(pIda!)','\(plan_category_id!)','\(plan_title!)','\(planTypeId!)','\(PlanDescription!)','\(planmaincatid!)','\(plansubcatid!)','\(inqueue!)','\(repetation!)','\(completedRepetation!)','\(isforcefully!)','\(isPremium!)','\(from_student!)')";
             
             //            let querySQL = "INSERT INTO Plan(plan_id, plan_category_id, plan_title, planTypeId,Plan_Desc,planmaincatid,plansubcatid,inqueue,repetation,completedRepetation,isforcefully,isPremium,from_student) VALUES ('\(PlanID)', '\(PlanCatID!)', '\(PlanTitle!)', '\(PlanTypeId!)', '\(Plandesc!)','\(planmaincatid!)','\(plansubcatid!)', '\(inqueue!)', '\(repetation!)', '\(completedRepetation!)', '\(isforcefully!)','\(isPremium!)','\(from_student!)')";
             print("query : \(querySQL)")
             //
             let flag: Bool
             
             flag =  database!.executeStatements(querySQL)
             
             print("flag : \(flag)")
             //print("isInserted : \(isInserted)")
             
             
             
             */
            
            
            
        }
        
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        
    }

    func Insert_PLAN_WS(_ All_Plan_WS: NSMutableArray)
    {
        print("\(All_Plan_WS)")
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        for i in 0 ..< All_Plan_WS.count
        {
            
            
//            let newArray = All_Plan_WS[i] as! NSDictionary
            var newArray : NSMutableDictionary = NSMutableDictionary()
            newArray = All_Plan_WS[i] as! NSMutableDictionary
            
          //  /* Change By Hardik
            
            let PlanID = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "PlanID")
            let PlanCatID =  (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "planCategoryId")
            
            let PlanTitle = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "PlanTitle")
            let PlanTypeId = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "planTypeId")
            
            var isPremium = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "isPremium")
            
            var Plandesc = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "PlanDescription")

            let desc = Plandesc as? NSString
            
            if desc?.lowercased.range(of:"'") != nil
            {
                Plandesc = (Plandesc as AnyObject).replacingOccurrences(of: "'", with: "`")
            }
            
            
            
             var from_student = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "from_student")
            
            
            if (from_student == nil)
            {
                from_student = "0"
            }
            
            if (isPremium == nil)
            {
                isPremium = "0"
            }

            var isforcefully = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "isforcefully")
            
            if (isforcefully == nil)
            {
                isforcefully = "0"
            }
            
            if isforcefully as! String == "1"
            {
                var action1 = ""
                var query_sql = ""
                action1 = "isforcefully"
                query_sql = "update Plan set \(action1) = 0"
                ModelManager.instance.update_forcefully(query_sql)
                UserDefaults.standard.set(PlanID as! String, forKey: "tea_actpid")
            }
            
            var inqueue = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "inqueue")
            
            if (inqueue == nil)
            {
                inqueue = ""
            }
            
            if inqueue as! String == "1"
            {
                var action1 = ""
                var query_sql = ""
                action1 = "inqueue"
                query_sql = "update Plan set \(action1) = 0"
                ModelManager.instance.update_forcefully(query_sql)
                UserDefaults.standard.set(PlanID as! String, forKey: "inqueue")
            }
            

            var repetation = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "repetation")
            
            if (repetation == nil)
            {
                repetation = "0"
            }
            
            var completedRepetation = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "completedRepetation")
            
            if (completedRepetation == nil)
            {
                completedRepetation = "0"
            }
            
            var planmaincatid = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "planmaincatid")
            
            
            if (planmaincatid == nil)
            {
                planmaincatid = "0"
            }

            var plansubcatid = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "plansubcatid")
            
            
            if (plansubcatid == nil)
            {
                plansubcatid = "0"
            }

             
             let querySQL = "INSERT OR REPLACE INTO Plan(plan_id, plan_category_id, plan_title, planTypeId,Plan_Desc,planmaincatid,plansubcatid,inqueue,repetation,completedRepetation,isforcefully,isPremium,from_student) VALUES ('\(PlanID!)', '\(PlanCatID!)', '\(PlanTitle!)', '\(PlanTypeId!)', '\(Plandesc!)','\(planmaincatid!)','\(plansubcatid!)', '\(inqueue!)', '\(repetation!)', '\(completedRepetation!)', '\(isforcefully!)','\(isPremium!)','\(from_student!)')";
            print("query : \(querySQL)")
            //
            let flag: Bool
            
            flag =  database!.executeStatements(querySQL)
            
            print("flag : \(flag)")
           // */
            
            
            
            /* Change By Hardik 26/5/17
            
            if let plansubcatid = newArray["plansubcatid"] as? String
            {
                newArray.setValue(plansubcatid, forKey: "plansubcatid")
            }
            else
            {
                newArray.setValue("0", forKey: "plansubcatid")
            }
            
            if let planmaincatid = newArray["planmaincatid"] as? String
            {
                newArray.setValue(planmaincatid, forKey: "planmaincatid")
            }
            else
            {
                newArray.setValue("0", forKey: "planmaincatid")
            }
            
            if let isPremium = newArray["isPremium"] as? String
            {
                newArray.setValue(isPremium, forKey: "isPremium")
            }
            else
            {
                newArray.setValue("0", forKey: "isPremium")
            }
            
            if let from_student1 = newArray["from_student"] as? String
            {
                newArray.setValue(from_student1, forKey: "from_student")
            }
            else
            {
                newArray.setValue("0", forKey: "from_student")
            }
            
            
            newArray.removeObject(forKey: "PlanCatID")
            
        //    let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Plan (plan_id,plan_category_id,plan_title,planTypeId,Plan_Desc,planmaincatid,plansubcatid,inqueue,repetation,completedRepetation,isforcefully,isPremium,from_student) VALUES (:PlanID, :planCategoryId, :PlanTitle, :planTypeId, :PlanDescription, :planmaincatid, :plansubcatid, :inqueue, :repetation, :completedRepetation, :isforcefully, :isPremium, :from_student)", withParameterDictionary : newArray as! [AnyHashable: Any]);
            
            let pIda = newArray.object(forKey:"PlanID")
//            let pId = pIds[0] as? String
//            let pIda = Int(pId!)// as? Num

            let planCategoryIds = newArray.object(forKey:"planCategoryId") as? NSArray
            let plan_category_id =  planCategoryIds?[0] as? String
            
            let plan_titles = newArray.object(forKey: "PlanTitle") as? NSArray
            let plan_title = plan_titles?[0] as? String
            
            let planTypeIdss = newArray.object(forKey:"planTypeId") as? NSArray
            let planTypeId = planTypeIdss?[0] as? String
            
            let PlanDescriptions = newArray.object(forKey:"PlanDescription") as? NSArray
            let PlanDescription = PlanDescriptions?[0] as? String

            let planmaincatid = newArray.value(forKey: "planmaincatid") as? String
            let plansubcatid = newArray.value(forKey: "plansubcatid") as? String
            let inqueue = newArray.value(forKey: "inqueue") as? String
            
            let repetations = newArray.value(forKey: "repetation") as? NSArray
            let repetation = repetations?[0] as? String
            
            let completedRepetations = newArray.object(forKey: "completedRepetation") as? NSArray
            let completedRepetation = completedRepetations?[0] as? String

            let isforcefully = newArray.value(forKey: "isforcefully") as?  String
            let isPremium = newArray.value(forKey: "isPremium") as? String
            let from_student = newArray.value(forKey: "from_student") as? String
            
         //hrdik   let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Plan (plan_id,plan_category_id,plan_title,planTypeId,Plan_Desc,planmaincatid,plansubcatid,inqueue,repetation,completedRepetation,isforcefully,isPremium,from_student) VALUES ('\(pId)','\(plan_category_id)','\(plan_title)','\(planTypeId)','\(PlanDescription)','\(planmaincatid)','\(plansubcatid)','\(inqueue)','\(repetation)','\(completedRepetation)','\(isforcefully)','\(isPremium)','\(from_student)')");
                //(?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?,?)
            
            
             let querySQL = "INSERT INTO Plan (plan_id,plan_category_id,plan_title,planTypeId,Plan_Desc,planmaincatid,plansubcatid,inqueue,repetation,completedRepetation,isforcefully,isPremium,from_student) VALUES ('\(pIda!)','\(plan_category_id!)','\(plan_title!)','\(planTypeId!)','\(PlanDescription!)','\(planmaincatid!)','\(plansubcatid!)','\(inqueue!)','\(repetation!)','\(completedRepetation!)','\(isforcefully!)','\(isPremium!)','\(from_student!)')";
            
//            let querySQL = "INSERT INTO Plan(plan_id, plan_category_id, plan_title, planTypeId,Plan_Desc,planmaincatid,plansubcatid,inqueue,repetation,completedRepetation,isforcefully,isPremium,from_student) VALUES ('\(PlanID)', '\(PlanCatID!)', '\(PlanTitle!)', '\(PlanTypeId!)', '\(Plandesc!)','\(planmaincatid!)','\(plansubcatid!)', '\(inqueue!)', '\(repetation!)', '\(completedRepetation!)', '\(isforcefully!)','\(isPremium!)','\(from_student!)')";
            print("query : \(querySQL)")
//            
            let flag: Bool
            
            flag =  database!.executeStatements(querySQL)
            
            print("flag : \(flag)")
        //print("isInserted : \(isInserted)")
            
            
            
            */
            
            
            
        }
        
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()

    }
    
    func Update_PLAN_WS(_ All_Plan_WS: NSMutableArray, planID : NSString)
    {
        print("\(All_Plan_WS)")
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        for i in 0 ..< All_Plan_WS.count
        {
            //            let newArray = All_Plan_WS[i] as! NSDictionary
            var newArray : NSMutableDictionary = NSMutableDictionary()
            newArray = All_Plan_WS[i] as! NSMutableDictionary
            
            //  /* Change By Hardik
            
            let PlanID = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "PlanID")
            let PlanCatID =  (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "planCategoryId")
            
            let PlanTitle = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "PlanTitle")
            let PlanTypeId = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "planTypeId")
            
            var isPremium = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "isPremium")
            
            var Plandesc = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "PlanDescription")
            
            let desc = Plandesc as? NSString
            
            if desc?.lowercased.range(of:"'") != nil
            {
                Plandesc = (Plandesc as AnyObject).replacingOccurrences(of: "'", with: "`")
            }
            
            var inqueue = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "inqueue")
            
            var from_student = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "from_student")
            
            if (inqueue == nil)
            {
                inqueue = ""
            }
            
            if (from_student == nil)
            {
                from_student = "0"
            }
            
            if (isPremium == nil)
            {
                isPremium = "0"
            }
            
            var isforcefully = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "isforcefully")
            
            if (isforcefully == nil)
            {
                isforcefully = "0"
            }
            
            var repetation = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "repetation")
            
            if (repetation == nil)
            {
                repetation = "0"
            }
            
            var completedRepetation = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "completedRepetation")
            
            if (completedRepetation == nil)
            {
                completedRepetation = "0"
            }
            
            var planmaincatid = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "planmaincatid")
            
            
            if (planmaincatid == nil)
            {
                planmaincatid = "0"
            }
            
            var plansubcatid = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "plansubcatid")
            
            
            if (plansubcatid == nil)
            {
                plansubcatid = "0"
            }
            
            
            
           // let querySQL = "update plan  set (plan_id, plan_category_id, plan_title, planTypeId,Plan_Desc,planmaincatid,plansubcatid,inqueue,repetation,completedRepetation,isforcefully,isPremium,from_student) VALUES ('\(PlanID!)', '\(PlanCatID!)', '\(PlanTitle!)', '\(PlanTypeId!)', '\(Plandesc!)','\(planmaincatid!)','\(plansubcatid!)', '\(inqueue!)', '\(repetation!)', '\(completedRepetation!)', '\(isforcefully!)','\(isPremium!)','\(from_student!)')  where plan_id = ('\(planID)')";
              
            let querySQL = "update plan  set  plan_id  = '\(PlanID!)',  plan_category_id  = '\(PlanCatID!)',  plan_title  = '\(PlanTitle!)', planTypeId  =  '\(PlanTypeId!)',  Plan_Desc  = '\(Plandesc!)', planmaincatid  = '\(planmaincatid!)', plansubcatid  = '\(plansubcatid!)',  inqueue  = '\(inqueue!)', repetation = '\(repetation!)', completedRepetation =  '\(completedRepetation!)', isforcefully  = '\(isforcefully!)',  isPremium = '\(isPremium!)', from_student  = '\(from_student!)'  where plan_id =  '\(planID)'";

            print("query : \(querySQL)")
            //
            let flag: Bool
            
            flag =  database!.executeStatements(querySQL)
            
            print("flag : \(flag)")
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        
    }
    
    func get_student_plan(_ query:String) -> NSDictionary
    {
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        let DicObj:NSMutableDictionary = NSMutableDictionary()

        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(query, withArgumentsIn: nil)
        
        let Plan_id: String = "plan_id"
        let PlancatID: String = "plan_category_id"
        let Plan_title: String = "plan_title"
        let Plan_Desc: String = "Plan_Desc"
        let PlanTypeID: String = "planTypeId"
        
        if (resultSet != nil) {
            while resultSet?.next() == true {
                print("plan_id : \(resultSet!.string(forColumn: Plan_id))")
                print("plan_category_id : \(resultSet!.string(forColumn: PlancatID))")
                print("plan_title : \(resultSet!.string(forColumn: Plan_title))")
                print("Plan_Desc : \(resultSet!.string(forColumn: Plan_Desc))")
                print("PlanTypeID : \(resultSet!.string(forColumn: PlanTypeID))")
                
                DicObj .setValue(resultSet!.string(forColumn: Plan_id), forKey: "plan_id")
                DicObj .setValue(resultSet!.string(forColumn: PlancatID), forKey: "plan_category_id")
                DicObj .setValue(resultSet!.string(forColumn: Plan_title), forKey: "plan_title")
                DicObj .setValue(resultSet!.string(forColumn: PlanTypeID), forKey: "PlanTypeID")
                DicObj .setValue(resultSet!.string(forColumn: Plan_Desc), forKey: "Plan_Desc")
            }
            
        }
        
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        
        return DicObj
    }
    
    
    func get_preum_plan(_ maincat:String,subcat:String) -> NSMutableArray
    {
      
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        
        var preplan = NSMutableArray()
        
        var querySQL =  NSString(format:"select * from Plan where planmaincatid =  \(maincat) AND plansubcatid = \(subcat)" as NSString)
        
        
        
              
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL as String!, withArgumentsIn: nil)
        
        let Plan_id: String = "plan_id"
        let PlancatID: String = "plan_category_id"
        let Plan_title: String = "plan_title"
        let Plan_Desc: String = "Plan_Desc"
        let PlanTypeID: String = "planTypeId"
        
        if (resultSet != nil) {
            while resultSet?.next() == true {
                print("plan_id : \(resultSet!.string(forColumn: Plan_id))")
                print("plan_category_id : \(resultSet!.string(forColumn: PlancatID))")
                print("plan_title : \(resultSet!.string(forColumn: Plan_title))")
                print("Plan_Desc : \(resultSet!.string(forColumn: Plan_Desc))")
                print("PlanTypeID : \(resultSet!.string(forColumn: PlanTypeID))")
                
                
                
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                
                DicObj .setValue(resultSet!.string(forColumn: Plan_id), forKey: "plan_id")
                DicObj .setValue(resultSet!.string(forColumn: PlancatID), forKey: "plan_category_id")
                DicObj .setValue(resultSet!.string(forColumn: Plan_title), forKey: "plan_title")
                DicObj .setValue(resultSet!.string(forColumn: PlanTypeID), forKey: "PlanTypeID")
                DicObj .setValue(resultSet!.string(forColumn: Plan_Desc), forKey: "Plan_Desc")
                
             preplan.add(DicObj)
            }
            
        }
        
        
        
        
        
        
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        
        
        
        return preplan
        
        
    }
    
    
    func Insert_PLAN_WS1(_ All_Plan_WS: NSMutableArray)
    {
        
        print("\(All_Plan_WS)")
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        //            let querySQL = "delete FROM Plan"
        //            let  xx : Bool
        //            xx =  sharedInstance.database!.executeUpdate(querySQL, withArgumentsInArray: nil)
        //            print("query : \(xx)")
        
        
        
        for i in 0 ..< All_Plan_WS.count
        {
            
            let PlanID = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "PlanID")
            print("\(PlanID)")
            let PlanCatID: String = ""
            print("\(PlanCatID)")
            let PlanTitle = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "PlanTitle")
            print("\(PlanTitle)")
            let PlanTypeId = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "planTypeId")
            print("\(PlanTypeId)")
            var Plandesc = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "PlanDescription")
            
            let desc = Plandesc as? NSString
            
            if desc?.lowercased.range(of:"'") != nil
            {
                Plandesc = (Plandesc as AnyObject).replacingOccurrences(of: "'", with: "`")
            }
            
            var inqueue = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "inqueue")
            
            var from_student = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "from_student")
            
            if (inqueue == nil)
            {
                inqueue = ""
            }
            
            if (from_student == nil)
            {
                from_student = "0"
            }
            
            
            var isforcefully = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "isforcefully")
            
            if (isforcefully == nil)
            {
                isforcefully = ""
            }
            
            var repetation = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "repetation")
            
            if (repetation == nil)
            {
                repetation = ""
            }
            
            var completedRepetation = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "completedRepetation")
            
            if (completedRepetation == nil)
            {
                completedRepetation = "0"
            }
            
            var planmaincatid = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "planmaincatid")
            
            
            if (planmaincatid == nil)
            {
                planmaincatid = "0"
            }
            
            var plansubcatid = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "plansubcatid")
            
            
            if (plansubcatid == nil)
            {
                plansubcatid = "0"
            }
            
            
            
//            let planmaincatid = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "planmaincatid")
//            let plansubcatid = (All_Plan_WS.object(at: i) as AnyObject).value(forKey: "plansubcatid")
            
            print("\(Plandesc)")
            
            let querySQL = "INSERT INTO Plan(plan_id, plan_category_id, plan_title, planTypeId, Plan_Desc,planmaincatid,plansubcatid) VALUES ('\(PlanID!)', '\(PlanCatID)', '\(PlanTitle!)', '\(PlanTypeId!)', '\(Plandesc!)','\(planmaincatid!)','\(plansubcatid!)')";
            print("query : \(querySQL)")
            
            let flag: Bool
            
            flag =  database!.executeStatements(querySQL)
            
            print("flag : \(flag)")
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
       
        
    }

    func select_category_by_plan(_ cateid:String)-> String
    {
        var category_name = ""
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        
        let querySQL = "select category_name from plan_category_master where plan_category_id = \(cateid) "
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        if (resultSet != nil) {
            while resultSet?.next() == true
            {
              category_name = resultSet!.string(forColumn: "category_name")
            }
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        return category_name
    }
    
    
    func Database_PlanCat(_ PurposeType: NSMutableArray){
        
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

        let querySQL = "select * from Plancategory"
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        let CategoryId: String = "CategoryId"
        let CategoryName: String = "CategoryName"
        if (resultSet != nil) {
            while resultSet?.next() == true {
                print("CategoryId : \(resultSet!.string(forColumn: CategoryId))")
                print("CategoryName : \(resultSet!.string(forColumn: CategoryName))")
                
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj .setValue(resultSet!.string(forColumn: CategoryId), forKey: "CategoryId")
                DicObj .setValue(resultSet!.string(forColumn: CategoryName), forKey: "CategoryName")
                PurposeType.add(DicObj)
            }
            
        }
         // sharedInstance.database?.commit()

        //  sharedInstance.database!.close()
        
    }
    
    
    func Insert_Plan_Category(_ PlancategoryID:String, PlancategoryName:String, userID:String, Editable:String)
    {
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
//        var catid:String = String()
//        var catname:String = String()
//        var Editable:String = String()
//        var userid:String = String()
//        
        
//        catid  = PlancategoryID
//        catname = PlancategoryName
//        Editable = Editable
//        userid = plasdetails.objectAtIndex(i).valueForKey("userId") as! String
        
        let querySQL = "INSERT INTO plan_category_master(plan_category_id, category_name, isEditable,userId) VALUES ('\(PlancategoryID)', '\(PlancategoryName)', '\(Editable)', '\(userID)')";
        print("query : \(querySQL)")
        
        let flag: Bool
        
        flag =  database!.executeStatements(querySQL)
        
        print("flag : \(flag)")

//        let querySQL = "INSERT INTO Plancategory(CategoryId, CategoryName) VALUES ('\(PlancategoryID)', '\(PlancategoryName)')";
//        print("query : \(querySQL)")
//        
//        let flag: Bool
//        
//        flag =  database!.executeStatements(querySQL)
//        
//        print("flag : \(flag)")
         // sharedInstance.database?.commit()

        //  sharedInstance.database!.close()
        
    }
    
    
    
    func get_plan_break_title(_ breakid:String) -> String
    {
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        
        var breaktitle = ""
        let query = "select PlanBreakTimeMili / 60000 as breaktitle from PlanBreak where PlanBreakID = \(breakid)"
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(query, withArgumentsIn: nil)
        
        if (resultSet != nil)
        {
            while resultSet?.next() == true
            {
                
              breaktitle =   resultSet!.string(forColumn: "breaktitle")
                
                
            }
        }
        
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
        return breaktitle
    }
    
    
    
    
    
    func Database_SelectedPlanData(_ planID: NSString ,selectedPlanArray: NSMutableArray)
    {
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        
        var resultSet: FMResultSet!
        
        sharedInstanceQueue.databaseQueue!.inDeferredTransaction { database, rollback in
            do
            {
                let querySQL = "select * from drill_plan_transaction DPT left outer join drill_Info di on DPT.drill_id = DI.drill_id inner join Drill_category_master dcm on di.category_id=dcm.category_id inner join  Drill_package dp on dp.drill_package_id=dcm.drill_package_id inner join Drill_main_category_master dmcm on dmcm.main_category_id=dp.main_category_id inner join Drill_color_master dcolm on dcolm.color_id=dp.color_id where DPT.plan_id =  \(planID) order by dayNo"
                
                print("flag : \(querySQL)")
                resultSet = try sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
            }
            catch
            {
                rollback!.pointee = true
                print(error)
            }
        }
        
        let Plan_Trans_ID: String = "plan_transaction_id"
        let Plan_Drill_ID: String = "drill_id"
        let Plan_id: String = "plan_id"
        let Plan_SequenceDrillID: String = "sequenceNo"
        let PlanBreak_ID: String = "planBreakId"
        let DayNo: String = "dayNo"
        
        let Drill_ID: String = "drill_id"
        let Drill_TITLE: String = "title"
        let Short_Desc: String = "abstract_description"
        let Long_Desc: String = "long_description"
        let Est_Time: String = "estimat_time"
        let EquityValue: String = "hundred_percent_equi_value"
        let Cat_ID: String = "category_id"
        let Diff_ID: String = "diffculty_type_id"
        let Focus_ID: String = "focus_type_id"
        let Shot_ID: String = "shot_type_id"
        let Training_ID: String = "traning_type_id"
        let Purpose_ID: String = "purpose_type_id"
        let Situation_ID: String = "situation_type_id"
        let MAT_ID: String = "metrix_id"
        let Total_Shots: String = "no_of_shots"
        let drillTypeId: String = "drillTypeid"
        let createduserId: String = "CreatedbyuserId"
        let Scorecard_desc: String = "Scorecard_desc"
        
        let categoryId: String = "category_id"
        let drill_package_id: String = "drill_package_id"
        let categoryname: String = "category_name"
        let color_id: String = "color_id"
        
        let drillpackageId: String = "drill_package_id"
        let main_category_id: String = "main_category_id"
        let color_id1: String = "color_id"
        let package_name: String = "package_name"
        
        let main_category_id1: String = "main_category_id"
        let main_category_name: String = "main_category_name"
        let color_id2: String = "color_id"
        let color_name: String = "color_name"
        let color_code: String = "color_code"
        let bcolorid = "color_id"
        
        if (resultSet != nil)
        {
            while resultSet?.next() == true {
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj .setValue(resultSet!.string(forColumn: Plan_Trans_ID), forKey: "Plan_Trans_ID")
                DicObj .setValue(resultSet!.string(forColumn: Plan_Drill_ID), forKey: "Plan_Drill_ID")
                DicObj .setValue(resultSet!.string(forColumn: Plan_id), forKey: "Plan_id")
                DicObj .setValue(resultSet!.string(forColumn: Plan_SequenceDrillID), forKey: "Plan_SequenceDrillID")
                DicObj .setValue(resultSet!.string(forColumn: PlanBreak_ID), forKey: "PlanBreak_ID")
                DicObj .setValue(resultSet!.string(forColumn: DayNo), forKey: "DayNo")
                DicObj .setValue(resultSet!.string(forColumn: Drill_ID), forKey: "Drill_ID")
                DicObj .setValue(resultSet!.string(forColumn: Drill_TITLE), forKey: "Drill_TITLE")
                DicObj .setValue(resultSet!.string(forColumn: Short_Desc), forKey: "Short_Desc")
                DicObj .setValue(resultSet!.string(forColumn: Long_Desc), forKey: "Long_Desc")
                DicObj .setValue(resultSet!.string(forColumn: Est_Time), forKey: "estimat_time")
                DicObj .setValue(resultSet!.string(forColumn: EquityValue), forKey: "hundred_percent_equi_value")
                DicObj .setValue(resultSet!.string(forColumn: Cat_ID), forKey: "Cat_ID")
                DicObj .setValue(resultSet!.string(forColumn: Diff_ID), forKey: "diffculty_type_id")
                DicObj .setValue(resultSet!.string(forColumn: Focus_ID), forKey: "focus_type_id")
                DicObj .setValue(resultSet!.string(forColumn: Shot_ID), forKey: "Shot_ID")
                DicObj .setValue(resultSet!.string(forColumn: Training_ID), forKey: "traning_type_id")
                DicObj .setValue(resultSet!.string(forColumn: Purpose_ID), forKey: "purpose_type_id")
                DicObj .setValue(resultSet!.string(forColumn: Situation_ID), forKey: "situation_type_id")
                DicObj .setValue(resultSet!.string(forColumn: MAT_ID), forKey: "MAT_ID")
                DicObj .setValue(resultSet!.string(forColumn: Total_Shots), forKey: "Total_Shots")
                DicObj .setValue(resultSet!.string(forColumn: drillTypeId), forKey: "drillTypeId")
                DicObj .setValue(resultSet!.string(forColumn: createduserId), forKey: "createduserId")
                DicObj .setValue(resultSet!.string(forColumn: Scorecard_desc), forKey: "Scorecard_desc")
                
                DicObj .setValue(resultSet!.string(forColumn: bcolorid), forKey: "bcolorid")
                DicObj .setValue(resultSet!.string(forColumn: categoryId), forKey: "categoryId")
                DicObj .setValue(resultSet!.string(forColumn: drill_package_id), forKey: "drill_package_id")
                DicObj .setValue(resultSet!.string(forColumn: categoryname), forKey: "categoryname")
                DicObj .setValue(resultSet!.string(forColumn: color_id), forKey: "color_id")
                
                DicObj .setValue(resultSet!.string(forColumn: drillpackageId), forKey: "drillpackageId")
                DicObj .setValue(resultSet!.string(forColumn: main_category_id), forKey: "main_category_id")
                DicObj .setValue(resultSet!.string(forColumn: color_id1), forKey: "color_id1")
                DicObj .setValue(resultSet!.string(forColumn: package_name), forKey: "package_name")
                
                DicObj .setValue(resultSet!.string(forColumn: main_category_id1), forKey: "main_category_id1")
                DicObj .setValue(resultSet!.string(forColumn: main_category_name), forKey: "main_category_name")
                DicObj .setValue(resultSet!.string(forColumn: color_id2), forKey: "color_id2")
                DicObj .setValue(resultSet!.string(forColumn: color_name), forKey: "color_name")
                DicObj .setValue(resultSet!.string(forColumn: color_code), forKey: "color_code")
                DicObj .setValue("ActualDrill", forKey: "type")
                
                selectedPlanArray.add(DicObj)
            }
            
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        
        
    }
    
    func Insert_UserDetail(_ UserDetail: NSMutableArray)
    {
        
        print(" \(UserDetail)")

        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

       
        
        for i in 0  ..< UserDetail.count
        {
            
            var DrillDetailInfo : NSMutableDictionary = NSMutableDictionary()
            DrillDetailInfo = UserDetail.object(at: i) as! NSMutableDictionary
            print("\(DrillDetailInfo)")
            
            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO User VALUES (:userId, :userName, :password, :firstName, :lastName, :emailId, :gender, :city, :status, :userType, :registerDate, :activeplanid, :teacherAssignedplan)", withParameterDictionary : DrillDetailInfo as! [AnyHashable: Any]);
            
            print("InsertData : \(isInserted))")
       
        }
       
         // sharedInstance.database?.commit()

        //  sharedInstance.database!.close()
   
    }
    func Insert_UserDetail1(_ UserDetail: NSMutableDictionary)
    {
        
        print(" \(UserDetail)")
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        let userid = UserDefaults.standard.object(forKey: "UserId") as! String
        
        let querySQL = "DELETE FROM User where userId = \(userid)"
                  
        let  xx : Bool
        xx =  sharedInstance.database!.executeUpdate(querySQL, withArgumentsIn: nil)
        
        print("query : \(xx)")
        
        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO User (userId,userName,password,firstName,lastName,emailId,address,gender,city,status,userType,registerDate,activeplanid,teacherAssignActivePlan,Phone,Country,State,userimage) VALUES (:userId, :userName, :password, :firstName, :lastName, :emailId, :address, :gender, :city, :status, :userType, :registerDate, :activeplanid, :teacherAssignActivePlan, :Phone, :Country, :State, :userimage)", withParameterDictionary : UserDetail as! [AnyHashable: Any]);
        
            print("InsertData : \(isInserted))")
        
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        
    }
   
    
    
    func Update_UserDetail(_ UserDetail: NSMutableDictionary, planTypeID : String)
    {
        
        print(" \(UserDetail)")
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        
        
        
        // let isInserted = sharedInstance.database!.executeUpdate("UPDATE MessageTable SET activeplanid = \"%@\" WHERE user_id = %@",
        
        
        if(planTypeID == "3")
        {
            
            let planid = UserDetail.value(forKey: "teacherAssignedActivePlanId") as! String
            print(planid)
            let userId1 = UserDetail.value(forKey: "userId") as! String
            print(userId1)
            
            let isInserted = sharedInstance.database!.executeUpdate("UPDATE User SET teacherAssignActivePlan = \(planid) WHERE userId = \(userId1)", withParameterDictionary : nil);
            
            print("InsertData : \(isInserted))")
            
            if isInserted
            {
                UserDefaults.standard.set(planid, forKey: "actpid")
                UserDefaults.standard.synchronize()
            }
            else
            {
                UserDefaults.standard.set("0", forKey: "actpid")
                UserDefaults.standard.synchronize()
            }
            
        }else{
            
            let planid = UserDetail.value(forKey: "activeplanid") as! String
            print(planid)
            let userId1 = UserDetail.value(forKey: "userId") as! String
            print(userId1)
        
        let isInserted = sharedInstance.database!.executeUpdate("UPDATE User SET activeplanid = \(planid) WHERE userId = \(userId1)", withParameterDictionary : nil);
        
        print("InsertData : \(isInserted))")
        
        if isInserted
        {
            UserDefaults.standard.set(planid, forKey: "actpid")
            UserDefaults.standard.synchronize()
        }
        else
        {
            UserDefaults.standard.set("0", forKey: "actpid")
            UserDefaults.standard.synchronize()
        }
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        
    }

    
    
    
    func User_Info(_ userArray : NSMutableArray){
        
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

        
        let querySQL = "select * from User"
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        let userId: String = "userId"
        let userName: String = "userName"
        let password: String = "password"
        let firstName: String = "firstName"
        let lastName: String = "lastName"
        let emailId: String = "emailId"
        let gender: String = "gender"
        let city: String = "city"
        let status: String = "status"
        let userType: String = "userType"
        let registerDate: String = "registerDate"
        let activeplanid: String = "activeplanid"
        let teacherAssignActivePlan: String = "teacherAssignActivePlan"

        
        if (resultSet != nil) {
            while resultSet?.next() == true {
                
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj .setValue(resultSet!.string(forColumn: userId), forKey: "userId")
                DicObj .setValue(resultSet!.string(forColumn: userName), forKey: "userName")
                DicObj .setValue(resultSet!.string(forColumn: password), forKey: "password")
                DicObj .setValue(resultSet!.string(forColumn: firstName), forKey: "firstName")
                DicObj .setValue(resultSet!.string(forColumn: lastName), forKey: "lastName")
                DicObj .setValue(resultSet!.string(forColumn: emailId), forKey: "emailId")
                DicObj .setValue(resultSet!.string(forColumn: gender), forKey: "gender")
                DicObj .setValue(resultSet!.string(forColumn: city), forKey: "city")
                DicObj .setValue(resultSet!.string(forColumn: status), forKey: "status")
                DicObj .setValue(resultSet!.string(forColumn: userType), forKey: "userType")
                DicObj .setValue(resultSet!.string(forColumn: registerDate), forKey: "registerDate")
                DicObj .setValue(resultSet!.string(forColumn: activeplanid), forKey: "activeplanid")
                DicObj .setValue(resultSet!.string(forColumn: teacherAssignActivePlan), forKey: "TeacherAssignedActiveplanid")

                userArray.add(DicObj)
            }
            
        }
         // sharedInstance.database?.commit()

        //  sharedInstance.database!.close()
        
    }
    
    
    func Database_PlanDetails(_ PlanArray: NSMutableArray, planId : NSString)  {
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

   
        let querySQL = NSString(format:"select * from Plan WHERE plan_id = %@", planId) as String
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        let Plan_id: String = "plan_id"
        let PlancatID: String = "plan_category_id"
        let Plan_title: String = "plan_title"
        let Plan_Desc: String = "Plan_Desc"
        let PlanTypeID: String = "planTypeId"
        
        
        if (resultSet != nil) {
            while resultSet?.next() == true
            {
                print("plan_id : \(resultSet!.string(forColumn: Plan_id))")
                print("plan_category_id : \(resultSet!.string(forColumn: PlancatID))")
                print("plan_title : \(resultSet!.string(forColumn: Plan_title))")
                print("Plan_Desc : \(resultSet!.string(forColumn: Plan_Desc))")
                print("PlanTypeID : \(resultSet!.string(forColumn: PlanTypeID))")
                
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj .setValue(resultSet!.string(forColumn: Plan_id), forKey: "plan_id")
                DicObj .setValue(resultSet!.string(forColumn: PlancatID), forKey: "plan_category_id")
                DicObj .setValue(resultSet!.string(forColumn: Plan_title), forKey: "plan_title")
                DicObj .setValue(resultSet!.string(forColumn: PlanTypeID), forKey: "PlanTypeID")
                DicObj .setValue(resultSet!.string(forColumn: Plan_Desc), forKey: "Plan_Desc")
                
                
                
                PlanArray.add(DicObj)
            }
            
        }
         // sharedInstance.database?.commit()

        //  sharedInstance.database!.close()
    }
    
    
    func Database_AllPlan(_ PlanArray: NSMutableArray)
    {
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        
        let querySQL = NSString(format:"select * from Plan")
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL as String!, withArgumentsIn: nil)
        
        let Plan_id: String = "plan_id"
        let PlancatID: String = "plan_category_id"
        let Plan_title: String = "plan_title"
        let Plan_Desc: String = "Plan_Desc"
        let PlanTypeID: String = "planTypeId"
        let inqueue: String = "inqueue"
        let forcefully: String = "isforcefully"
        
        
        if (resultSet != nil) {
            while resultSet?.next() == true
            {
                print("plan_id : \(resultSet!.string(forColumn: Plan_id))")
                print("plan_category_id : \(resultSet!.string(forColumn: PlancatID))")
                print("plan_title : \(resultSet!.string(forColumn: Plan_title))")
                print("Plan_Desc : \(resultSet!.string(forColumn: Plan_Desc))")
                print("PlanTypeID : \(resultSet!.string(forColumn: PlanTypeID))")
                
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj .setValue(resultSet!.string(forColumn: Plan_id), forKey: "plan_id")
                DicObj .setValue(resultSet!.string(forColumn: PlancatID), forKey: "plan_category_id")
                DicObj .setValue(resultSet!.string(forColumn: Plan_title), forKey: "plan_title")
                DicObj .setValue(resultSet!.string(forColumn: PlanTypeID), forKey: "PlanTypeID")
                DicObj .setValue(resultSet!.string(forColumn: Plan_Desc), forKey: "Plan_Desc")
                DicObj .setValue(resultSet!.string(forColumn: inqueue), forKey: "inqueue")
                DicObj .setValue(resultSet!.string(forColumn: forcefully), forKey: "isforcefully")
                
                
                
                PlanArray.add(DicObj)
            }
            
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
    }

    func Drill_exp_mat_value(_ DrillId : NSString)->NSMutableArray
    {
        
        let ExpMatValue : NSMutableArray = NSMutableArray()
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        
        let querySQL = "select * from Drill_matrix_expected_value where drill_id = '\(DrillId)'"
        print(querySQL)
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        let Drill_matrix_exp_value_id: String = "drill_matrix_exp_val_id"
        let drill_id: String = "drill_id"
        let row_no: String = "row_no"
        let col_no: String = "col_no"
        let minimumValue: String = "minimumValue"
        let matrixCellDinamicId: String = "matrixCellDinamicId"
        
        if (resultSet != nil) {
            while resultSet?.next() == true {
                
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj .setValue(resultSet!.string(forColumn: Drill_matrix_exp_value_id), forKey: "drill_matrix_exp_val_id")
                DicObj .setValue(resultSet!.string(forColumn: drill_id), forKey: "drill_id")
                DicObj .setValue(resultSet!.string(forColumn: row_no), forKey: "row_no")
                DicObj .setValue(resultSet!.string(forColumn: col_no), forKey: "col_no")
                DicObj .setValue(resultSet!.string(forColumn: minimumValue), forKey: "minimumValue")
                DicObj .setValue(resultSet!.string(forColumn: matrixCellDinamicId), forKey: "matrixCellDinamicId")
                
                ExpMatValue.add(DicObj)
            }
            
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        return ExpMatValue
    }
    
    func Drill_exp_mat_value1(_ DrillId : NSString)->NSMutableArray
    {
        
        let ExpMatValue : NSMutableArray = NSMutableArray()
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        
        let querySQL = "select * from Drill_Result_matrixValue where drillresultMetrixId = '\(DrillId)'"
        print(querySQL)
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        let Drill_matrix_exp_value_id: String = "drill_matrix_exp_val_id"
        let drill_id: String = "drill_id"
        let row_no: String = "row_no"
        let col_no: String = "col_no"
        let minimumValue: String = "minimumValue"
        let matrixCellDinamicId: String = "matrixCellDinamicId"
        
        if (resultSet != nil) {
            while resultSet?.next() == true {
                
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj .setValue(resultSet!.string(forColumn: "resultmatrixValueId"), forKey: "resultmatrixValueId")
                DicObj .setValue(resultSet!.string(forColumn: "drillresultMetrixId"), forKey: "drillresultMetrixId")
                DicObj .setValue(resultSet!.string(forColumn: "drillresultmetrixRow"), forKey: "drillresultmetrixRow")
                DicObj .setValue(resultSet!.string(forColumn: "drillresultmetrixCol"), forKey: "drillresultmetrixCol")
                DicObj .setValue(resultSet!.string(forColumn: "drillresultMetrixValue"), forKey: "drillresultMetrixValue")
                ExpMatValue.add(DicObj)
            }
            
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        return ExpMatValue
    }
    
    func Drill_Label(_ DrillId : NSString)->NSMutableArray
    {
        
        let ExpMatLabel : NSMutableArray = NSMutableArray()
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        
        let querySQL = "select * from Drill_matrix_expected_label where drill_id = \(DrillId)"
        print(querySQL)
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        let Drill_matrix_label_id: String = "id"
        let drill_id: String = "drill_id"
        let row_label: String = "row_label"
        let col_label: String = "col_lable"
        let value: String = "value"
        
        if (resultSet != nil) {
            while resultSet?.next() == true {
                
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj .setValue(resultSet!.string(forColumn: Drill_matrix_label_id), forKey: "Drill_matrix_label_id")
                DicObj .setValue(resultSet!.string(forColumn: drill_id), forKey: "drill_id")
                DicObj .setValue(resultSet!.string(forColumn: row_label), forKey: "row_label")
                DicObj .setValue(resultSet!.string(forColumn: col_label), forKey: "col_label")
                DicObj .setValue(resultSet!.string(forColumn: value), forKey: "value")
                
                ExpMatLabel.add(DicObj)
            }
            
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        return ExpMatLabel
    }
    
    
    
    func chekresultmatrix() -> Bool
    {
        
        var check = false
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        let userid = UserDefaults.standard.object(forKey: "UserId") as! String
        
        let querySQL = "SELECT * FROM Result_Metrix where userId = \(userid)"
        
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
       
        
       
        if (resultSet != nil) {
            while resultSet?.next() == true
            {
                        check = true
            }
        }
        
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        
        
        return check
    }
    
    
    func Insert_UserDetail2(_ UserDetail: NSMutableArray)
    {
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

        
        for i in 0  ..< UserDetail.count
        {
            
            var DrillDetailInfo : NSMutableDictionary = NSMutableDictionary()
            DrillDetailInfo = UserDetail.object(at: i) as! NSMutableDictionary
            print("\(DrillDetailInfo)")
            
            
            DrillDetailInfo.removeObject(forKey: "userRelationshipId")
            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO User(userId,userName,emailId,status,activeplanid,userimage) VALUES (:userId, :userName, :emailId,  :status,  :activePlanId, :profilePic)", withParameterDictionary : DrillDetailInfo as! [AnyHashable: Any]);
            
            print("InsertData : \(isInserted))")
            
        }
        
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()

        
    }
    
    func Insert_ResultMetrix(_ ResultMetrixDetail: NSMutableArray)
    {
        
        
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        //        let querySQL = "delete FROM Result_Metrix"
        //        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsInArray: nil)
        
        //  print("query : \(resultSet.resultDictionary())")
        
        print(" \(ResultMetrixDetail)")
        
        for i in 0 ..< ResultMetrixDetail.count 
        {
            
            let DrillResultMetrixID = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey : "drillResultMetrixId")
            let UserID = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey : "userId")
            
            
            let PlanID = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey : "planId")
            let Comment = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey : "comment")
            let TotalResult = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey : "totalResult")
            let DrillResultTime = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey : "drillResultTime")
            let plan_tran_id = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "drillPlanTransactionId")
            let totalResult = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "totalResult") as! String
            let result_value = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "result_value") as! String
            let Data : NSMutableDictionary = NSMutableDictionary()
            Data.setValue(DrillResultMetrixID, forKey: "DrillResultMetrixID")
            Data.setValue(UserID, forKey: "UserID")
            Data.setValue(DrillID, forKey: "DrillID")
            Data.setValue(PlanID, forKey: "PlanID")
            Data.setValue(Comment, forKey: "Comment")
            Data.setValue(totalResult, forKey: "TotalResult")
            Data.setValue(DrillResultTime, forKey: "DrillResultTime")
            Data.setValue(plan_tran_id, forKey: "drillPlanTransactionId")
            Data.setValue("0", forKey: "result_val")
            print("\(Data)")
            
            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Result_Metrix(drillResultMetrixid, userId,drillId,planId,comment,totalResult,drillresultTime,drillPlanTransactionId,result_val) VALUES (:DrillResultMetrixID, :UserID, :DrillID, :PlanID, :Comment, :TotalResult, :DrillResultTime,:drillPlanTransactionId,:result_val)", withParameterDictionary : Data as! [AnyHashable: Any]);
            print("InsertData : \(isInserted))")
            
            
            
            var newDataArray : NSMutableArray = NSMutableArray()
            newDataArray = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "studentResultValue") as! NSMutableArray
            // ModelManager.instance.Insert_Result_Metrix_Value(newDataArray, DrillresultmetrixID: DrillResultMetrixID!)
            
            print(newDataArray);
            
            for i in 0 ..< newDataArray.count 
            {
                
                let resultmatrixvalueId = (newDataArray.object(at: i)as AnyObject).value(forKey: "resultMatrixValuesId")
                let drillresultMetrixId = DrillResultMetrixID!
                let drillresultmetrixRow = (newDataArray.object(at: i)as AnyObject).value(forKey: "drillResultMetrixRow")
                let drillresultmetrixCol = (newDataArray.object(at: i)as AnyObject).value(forKey: "drillResultMetrixCol")
                let drillresultmetrixValue = (newDataArray.object(at: i)as AnyObject).value(forKey: "drillResultMetrixValue")
                
                let Data : NSMutableDictionary = NSMutableDictionary()
                Data.setValue(resultmatrixvalueId, forKey: "resultmatrixvalueId")
                Data.setValue(drillresultMetrixId, forKey: "drillresultMetrixId")
                Data.setValue(drillresultmetrixRow, forKey: "drillresultmetrixRow")
                Data.setValue(drillresultmetrixCol, forKey: "drillresultmetrixCol")
                Data.setValue(drillresultmetrixValue, forKey: "drillresultmetrixValue")
                
                let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Drill_Result_matrixValue VALUES (:resultmatrixvalueId, :drillresultMetrixId, :drillresultmetrixRow, :drillresultmetrixCol, :drillresultmetrixValue)", withParameterDictionary : Data as! [AnyHashable: Any]);
                
                print("InsertData : \(isInserted))")
                
                
            }
            
            
        }
        
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
        
//        for i in 0 ..< ResultMetrixDetail.count 
//        {
//            
//            let DrillResultMetrixID = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "drillResultMetrixId") as! String
//            
//            let DrillID = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey : "drillId")
//            
//            
//            let shot_id = ModelManager.instance.get_shot_id(DrillID as! String)
//            let no_of_shot = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "Equivalent_Value") as! String
//            
//            ModelManager.instance.calculate_result(DrillResultMetrixID as! String,total_result: no_of_shot ,shottype: shot_id)
//         }
      }
    
    func Insert_ResultMetrix1(_ ResultMetrixDetail: NSMutableArray,fromview:String)
    {
        
        print("asdasd")
        
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        //        let querySQL = "delete FROM Result_Metrix"
        //        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsInArray: nil)
        //
        //        print("query : \(resultSet.resultDictionary())")
        
        print(" \(ResultMetrixDetail)")
        
        for i in 0 ..< ResultMetrixDetail.count 
        {
            let DrillResultMetrixID = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "drillResultMetrixId")
            let UserID = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "userId")
            let DrillID = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "drillId")
            let PlanID = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "planId")
            
            let Comment = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "comment")
            let TotalResult = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "totalResult")
            let DrillResultTime = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "drillResultTime")
            let plan_tran_id = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "drillPlanTransactionId")
            //            let no_of_shot = ResultMetrixDetail.objectAtIndex(i).valueForKey("numberOfShots") as! String
            let result = Int(Float((ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "result_value") as! String)!)
            let Data : NSMutableDictionary = NSMutableDictionary()
            Data.setValue(DrillResultMetrixID, forKey: "DrillResultMetrixID")
            Data.setValue(UserID, forKey: "UserID")
            Data.setValue(DrillID, forKey: "DrillID")
            Data.setValue(PlanID, forKey: "PlanID")
            Data.setValue(Comment, forKey: "Comment")
            Data.setValue(TotalResult, forKey: "TotalResult")
            Data.setValue((ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "repetation"), forKey: "repetation")
            
            Data.setValue(DrillResultTime, forKey: "DrillResultTime")
            Data.setValue(plan_tran_id, forKey: "drillPlanTransactionId")
            
            Data.setValue(String(result), forKey: "result_val")
            print("\(Data)")
            
            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Result_Metrix(drillResultMetrixid, userId,drillId,planId,comment,totalResult,drillresultTime,drillPlanTransactionId,result_val,repetation) VALUES (:DrillResultMetrixID, :UserID, :DrillID, :PlanID, :Comment, :TotalResult, :DrillResultTime,:drillPlanTransactionId,:result_val,:repetation)", withParameterDictionary : Data as! [AnyHashable: Any]);
            print("InsertData : \(isInserted))")
            
            var newDataArray : NSMutableArray = NSMutableArray()
            newDataArray = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "drillResultMatrixValues") as! NSMutableArray
            
            print(newDataArray);
            
            for i in 0 ..< newDataArray.count 
            {
                
                let resultmatrixvalueId = (newDataArray.object(at: i) as AnyObject).value(forKey: "resultMatrixValuesId")
                let drillresultMetrixId = DrillResultMetrixID!
                let drillresultmetrixRow = (newDataArray.object(at: i) as AnyObject).value(forKey: "drillResultMetrixRow")
                let drillresultmetrixCol = (newDataArray.object(at: i) as AnyObject).value(forKey: "drillResultMetrixCol")
                let drillresultmetrixValue = (newDataArray.object(at: i) as AnyObject).value(forKey: "drillResultMetrixValue")
                
                let Data : NSMutableDictionary = NSMutableDictionary()
                Data.setValue(resultmatrixvalueId, forKey: "resultmatrixvalueId")
                Data.setValue(drillresultMetrixId, forKey: "drillresultMetrixId")
                Data.setValue(drillresultmetrixRow, forKey: "drillresultmetrixRow")
                Data.setValue(drillresultmetrixCol, forKey: "drillresultmetrixCol")
                Data.setValue(drillresultmetrixValue, forKey: "drillresultmetrixValue")
                
                let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Drill_Result_matrixValue VALUES (:resultmatrixvalueId, :drillresultMetrixId, :drillresultmetrixRow, :drillresultmetrixCol, :drillresultmetrixValue)", withParameterDictionary : Data as! [AnyHashable: Any]);
                
                print("InsertData : \(isInserted))")
            }
        }
        
        
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
        
//        for i in 0..<ResultMetrixDetail.count
//        {
//            
//            let DrillResultMetrixID = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "drillResultMetrixId") as! String
//            let TotalResult = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "totalResult") as! String
//            
//            var shottype = ModelManager.instance.get_shot_id((ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "drillId") as! String)
//            if shottype == ""
//            {
//                shottype =  common_controller.sharedInstance.shot_type
//            }
//            
//            self.calculate_result(DrillResultMetrixID, total_result: TotalResult,shottype: shottype)
//         }
      }
    
    func get_result(_ tran_id:String) -> String
    {
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        var sum = ""
         let querySQL = "select result_val from Result_Metrix where drillResultMetrixId = \(tran_id)"
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        while resultSet?.next() == true
        {
            
            sum = resultSet!.string(forColumn: "result_val")
            
            
        }
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
        return sum
        
    }
    
    func get_shot_id(_ drillid:String) -> String
    {
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        var shotid = ""
        let querySQL = "select shot_type_id from Drill_info where drill_id = \(drillid)"
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        while resultSet?.next() == true
        {
            shotid = resultSet!.string(forColumn: "shot_type_id")
        }
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
        return shotid
        
    }
    
    func calculate_result1(_ result_mat_id:String,total_result:String,shottype:String) -> String
    {
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        print(result_mat_id)
        let querySQL = "select Sum(drillresultmetrixValue) as result_val from Drill_Result_matrixValue where drillresultMetrixId = \(result_mat_id)"
        var sum = ""
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        while resultSet?.next() == true
        {
            sum = resultSet!.string(forColumn: "result_val")
        }
        
        var total_result_value = 0.0
        
        if sum != "0"
        {
            
            if shottype == "1"
            {
                total_result_value  = (Double(sum)!*100)/Double(total_result)!
            }
            else
            {
                total_result_value  = (Double(total_result)!*100)/Double(sum)!
            }
        }
        else
        {
            total_result_value = 0.0
        }
        
        total_result_value =   round(total_result_value)
        
        var query2 = "update Result_Metrix set result_val = \(Int(total_result_value)) where drillResultMetrixId = \(result_mat_id)"
        
        
        let isInserted =    sharedInstance.database!.executeUpdate(query2,withArgumentsIn: nil)
        
        print(query2)
        
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
        
        return  "\(total_result_value)"
    }
    
    func calculate_result(_ result_mat_id:String,total_result:String,shottype:String)
    {
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        print(result_mat_id)
        let querySQL = "select Sum(drillresultmetrixValue) as result_val from Drill_Result_matrixValue where drillresultMetrixId = \(result_mat_id)"
        var sum = ""
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        while resultSet?.next() == true
        {
            sum = resultSet!.string(forColumn: "result_val")
        }
        
         var total_result_value = 0.0
        
        if sum != "0"
        {
        
        if shottype == "1"
        {
           total_result_value  = (Double(sum)!*100)/Double(total_result)!
        }
        else
        {
            total_result_value  = (Double(total_result)!*100)/Double(sum)!
        }
        }
        else
        {
            total_result_value = 0.0
        }
        
      total_result_value =   round(total_result_value)
        
        let query2 = "update Result_Metrix set result_val = \(Int(total_result_value)) where drillResultMetrixId = \(result_mat_id)"
        
        
    let isInserted =    sharedInstance.database!.executeUpdate(query2,withArgumentsIn: nil)
        
        print(query2)

         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
        
    }
    
    
    
    
    
    func Insert_Result_Metrix_Value(_ ResultMetrixValueDetail: NSMutableArray,DrillresultmetrixID: AnyObject)
    {
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

        print(" \(ResultMetrixValueDetail)")

        for i in 0 ..< ResultMetrixValueDetail.count 
        {
            
            let resultmatrixvalueId = (ResultMetrixValueDetail.object(at: i) as AnyObject).value(forKey: "resultMatrixValuesId")
            let drillresultMetrixId = DrillresultmetrixID
            let drillresultmetrixRow = (ResultMetrixValueDetail.object(at: i) as AnyObject).value(forKey: "drillResultMetrixRow")
            let drillresultmetrixCol = (ResultMetrixValueDetail.object(at: i) as AnyObject).value(forKey: "drillResultMetrixCol")
            let drillresultmetrixValue = (ResultMetrixValueDetail.object(at: i) as AnyObject).value(forKey: "drillResultMetrixValue") as! String
            
            let Data : NSMutableDictionary = NSMutableDictionary()
            Data.setValue(resultmatrixvalueId, forKey: "resultmatrixvalueId")
            Data.setValue(drillresultMetrixId, forKey: "drillresultMetrixId")
            Data.setValue(drillresultmetrixRow, forKey: "drillresultmetrixRow")
            Data.setValue(drillresultmetrixCol, forKey: "drillresultmetrixCol")
            Data.setValue(drillresultmetrixValue, forKey: "drillresultmetrixValue")

            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Drill_Result_matrixValue VALUES (:resultmatrixvalueId, :drillresultMetrixId, :drillresultmetrixRow, :drillresultmetrixCol, :drillresultmetrixValue)", withParameterDictionary : Data as! [AnyHashable: Any]);
        
                print("InsertData : \(isInserted))")
            
        }
         // sharedInstance.database?.commit()

       //  sharedInstance.database!.close()
        
    }
    
    
    func Insert_StudentResultMetrix(_ ResultMetrixDetail: NSMutableArray,userId : String)
    {
        
        sharedInstance.database!.open()
        
        // sharedInstance.database?.beginTransaction()
        
        print(" \(ResultMetrixDetail)")
        
        for i in 0 ..< ResultMetrixDetail.count
        {
            print("Debug student : " ,i)
            
            let DrillResultMetrixID = (ResultMetrixDetail.object(at: i) as! NSDictionary).value(forKey: "drillResultMetrixId") as! String
            let DrillID = (ResultMetrixDetail.object(at: i) as! NSDictionary).value(forKey: "drillId") as! String
            
            let PlanID = (ResultMetrixDetail.object(at: i) as! NSDictionary).value(forKey: "planId") as! String
            let drillPlanTransactionId  = (ResultMetrixDetail.object(at: i) as! NSDictionary).value(forKey: "drillPlanTransactionId") as! String
            let totalResult = (ResultMetrixDetail.object(at: i) as! NSDictionary).value(forKey: "totalResult") as! String
            let currentRepetation = (ResultMetrixDetail.object(at: i) as! NSDictionary).value(forKey: "repetation") as! String
            let result_value = Int(Float((ResultMetrixDetail.object(at: i) as! NSDictionary).value(forKey: "result_value") as! String)!)
            let DrillResultTime = (ResultMetrixDetail.object(at: i) as! NSDictionary).value(forKey: "drillResultTime") as! String
            
            
            let Data : NSMutableDictionary = NSMutableDictionary()
            Data.setValue(DrillResultMetrixID, forKey: "drillResultMetrixid")
            Data.setValue(userId, forKey: "userId")
            Data.setValue(DrillID, forKey: "drillId")
            Data.setValue(PlanID, forKey: "planId")
            Data.setValue((ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "comment") as! String, forKey: "comment")
            Data.setValue(totalResult, forKey: "totalResult")
            Data.setValue(DrillResultTime, forKey: "drillresultTime")
            Data.setValue(drillPlanTransactionId, forKey: "drillPlanTransactionId")
            Data.setValue(String(result_value), forKey: "result_val")
            Data.setValue(currentRepetation, forKey: "repetation")
            
            
            let isInserted = sharedInstance.database!.executeUpdate("INSERT OR IGNORE INTO Result_Metrix(drillResultMetrixid, userId,drillId,planId,comment,totalResult,drillresultTime,drillPlanTransactionId,result_val,repetation) VALUES (:drillResultMetrixid, :userId, :drillId, :planId, :comment, :totalResult, :drillresultTime,:drillPlanTransactionId,:result_val,:repetation)", withParameterDictionary : Data as! [AnyHashable: Any]);
            print("InsertData : \(isInserted))")
            
            var newDataArray : NSMutableArray = NSMutableArray()
            
            if (ResultMetrixDetail.object(at: i) as! NSDictionary).value(forKey: "studentResultValue")   != nil
            {
                newDataArray = ((ResultMetrixDetail.object(at: i) as! NSDictionary).value(forKey: "studentResultValue") as! NSArray).mutableCopy() as! NSMutableArray
            }
            
            if (ResultMetrixDetail.object(at: i) as! NSDictionary).value(forKey: "ownPlanResultValue")   != nil
            {
                newDataArray = ((ResultMetrixDetail.object(at: i) as! NSDictionary).value(forKey: "ownPlanResultValue") as! NSArray).mutableCopy() as! NSMutableArray
            }
            
//            (parseJSON["teacherAsssignPlan"]! as! NSArray).mutableCopy() as! NSMutableArray
            print(newDataArray);
            
            for i in 0 ..< newDataArray.count
            {
                
                let resultmatrixvalueId = (newDataArray.object(at: i) as! NSDictionary).value(forKey: "resultMatrixValuesId") as! String
                let drillresultMetrixId = DrillResultMetrixID
                let drillresultmetrixRow = (newDataArray.object(at: i) as! NSDictionary).value(forKey: "drillResultMetrixRow") as! String
                let drillresultmetrixCol = (newDataArray.object(at: i) as! NSDictionary).value(forKey: "drillResultMetrixCol") as! String
                let drillresultmetrixValue = (newDataArray.object(at: i) as! NSDictionary).value(forKey: "drillResultMetrixValue") as! String
                
                let Data : NSMutableDictionary = NSMutableDictionary()
                Data.setValue(resultmatrixvalueId, forKey: "resultmatrixvalueId")
                Data.setValue(drillresultMetrixId, forKey: "drillresultMetrixId")
                Data.setValue(drillresultmetrixRow, forKey: "drillresultmetrixRow")
                Data.setValue(drillresultmetrixCol, forKey: "drillresultmetrixCol")
                Data.setValue(drillresultmetrixValue, forKey: "drillresultmetrixValue")
                
                let isInserted = sharedInstance.database!.executeUpdate("INSERT OR IGNORE INTO Drill_Result_matrixValue VALUES (:resultmatrixvalueId, :drillresultMetrixId, :drillresultmetrixRow, :drillresultmetrixCol, :drillresultmetrixValue)", withParameterDictionary : Data as! [AnyHashable: Any]);
                
                print("InsertData : \(isInserted))")
                
            }
            
            let drillLabelArray : NSMutableArray = ((ResultMetrixDetail.object(at: i) as! NSDictionary).value(forKey: "drillLabels") as! NSArray).mutableCopy() as! NSMutableArray
            
            for j in 0 ..< drillLabelArray.count
            {
                
                
                let columnPos = (drillLabelArray.object(at: j) as! NSDictionary).value(forKey: "coulmnPos") as! String
                let drillId = (drillLabelArray.object(at: j) as! NSDictionary).value(forKey: "drillId") as! String
                let drillMatrixLabelsId = (drillLabelArray.object(at: j) as! NSDictionary).value(forKey: "drillMatrixLabelsId") as! String
                let rowPos = (drillLabelArray.object(at: j) as! NSDictionary).value(forKey: "rowPos") as! String
                let value = (drillLabelArray.object(at: j) as! NSDictionary).value(forKey: "value") as! String
                
                let drillData : NSMutableDictionary = NSMutableDictionary()
                drillData.setValue(columnPos, forKey: "coulmnPos")
                drillData.setValue(drillId, forKey: "drillId")
                drillData.setValue(drillMatrixLabelsId, forKey: "drillMatrixLabelsId")
                drillData.setValue(rowPos, forKey: "rowPos")
                drillData.setValue(value, forKey: "value")
                print(drillData)
                
                sharedInstanceQueue.databaseQueue!.inDeferredTransaction { database, rollback in
                    do {
                        
                        let isInserted = try sharedInstance.database!.executeUpdate("INSERT OR IGNORE INTO Drill_matrix_expected_label(id, drill_id, row_label, col_lable, value) VALUES (:drillMatrixLabelsId, :drillId, :rowPos, :coulmnPos, :value)", withParameterDictionary : drillData as! [AnyHashable: Any]);
                        print(isInserted)
                     } catch {
                        rollback!.pointee = true
                        print(error)
                    }
                }
                
//                let isInserted = sharedInstance.database!.executeUpdate("INSERT OR IGNORE INTO Drill_matrix_expected_label(id, drill_id, row_label, col_lable, value) VALUES (:drillMatrixLabelsId, :drillId, :rowPos, :coulmnPos, :value)", withParameterDictionary : drillData as! [AnyHashable: Any]);
//                print(isInserted)
            }
        }
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
    }
    
    func isKeyExistInUserDefault(kUsernameKey: String) -> Bool
    {
        return UserDefaults.standard.object(forKey: kUsernameKey) != nil
    }
    
    func Insert_ResultMetrix2(_ ResultMetrixDetail: NSMutableArray,userId : String)
    {
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        print(" \(ResultMetrixDetail)")
        
        for i in 0 ..< ResultMetrixDetail.count 
        {
            
            let DrillResultMetrixID = (ResultMetrixDetail.object(at: i) as! NSDictionary).value(forKey: "drillResultMetrixId") as! String
            let DrillID = (ResultMetrixDetail.object(at: i) as! NSDictionary).value(forKey: "drillId") as! String
            
            let PlanID = (ResultMetrixDetail.object(at: i) as! NSDictionary).value(forKey: "planId") as! String
            let drillPlanTransactionId  = (ResultMetrixDetail.object(at: i) as! NSDictionary).value(forKey: "drillPlanTransactionId") as! String
            let totalResult = (ResultMetrixDetail.object(at: i) as! NSDictionary).value(forKey: "totalResult") as! String
            let currentRepetation = (ResultMetrixDetail.object(at: i) as! NSDictionary).value(forKey: "actual_repetation") as! String
            let result_value = Int(Float((ResultMetrixDetail.object(at: i) as! NSDictionary).value(forKey: "result_value") as! String)!)
            let DrillResultTime = (ResultMetrixDetail.object(at: i) as! NSDictionary).value(forKey: "drillResultTime") as! String
            
            
            let Data : NSMutableDictionary = NSMutableDictionary()
            Data.setValue(DrillResultMetrixID, forKey: "drillResultMetrixid")
            Data.setValue(userId, forKey: "userId")
            Data.setValue(DrillID, forKey: "drillId")
            Data.setValue(PlanID, forKey: "planId")
            Data.setValue((ResultMetrixDetail.object(at: i) as! NSDictionary).value(forKey: "comment") as! String, forKey: "comment")
            Data.setValue(totalResult, forKey: "totalResult")
            Data.setValue(DrillResultTime, forKey: "drillresultTime")
            Data.setValue(drillPlanTransactionId, forKey: "drillPlanTransactionId")
            Data.setValue(String(result_value), forKey: "result_val")
            Data.setValue(currentRepetation, forKey: "repetation")
            
            
            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Result_Metrix(drillResultMetrixid, userId,drillId,planId,comment,totalResult,drillresultTime,drillPlanTransactionId,result_val,repetation) VALUES (:drillResultMetrixid, :userId, :drillId, :planId, :comment, :totalResult, :drillresultTime,:drillPlanTransactionId,:result_val,:repetation)", withParameterDictionary : Data as! [AnyHashable: Any]);
            print("InsertData : \(isInserted))")
            
            
            
            var newDataArray : NSMutableArray = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "teacherAssignedPlaResultValue") as! NSMutableArray
            
            print(newDataArray);
            
            for i in 0 ..< newDataArray.count
            {
                
                let resultmatrixvalueId = (newDataArray.object(at: i) as! NSDictionary).value(forKey: "resultMatrixValuesId") as! String
                let drillresultMetrixId = DrillResultMetrixID
                let drillresultmetrixRow = (newDataArray.object(at: i) as! NSDictionary).value(forKey: "drillResultMetrixRow") as! String
                let drillresultmetrixCol = (newDataArray.object(at: i) as! NSDictionary).value(forKey: "drillResultMetrixCol") as! String
                let drillresultmetrixValue = (newDataArray.object(at: i) as! NSDictionary).value(forKey: "drillResultMetrixValue") as! String
                
                let Data : NSMutableDictionary = NSMutableDictionary()
                Data.setValue(resultmatrixvalueId, forKey: "resultmatrixvalueId")
                Data.setValue(drillresultMetrixId, forKey: "drillresultMetrixId")
                Data.setValue(drillresultmetrixRow, forKey: "drillresultmetrixRow")
                Data.setValue(drillresultmetrixCol, forKey: "drillresultmetrixCol")
                Data.setValue(drillresultmetrixValue, forKey: "drillresultmetrixValue")
                
                let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Drill_Result_matrixValue VALUES (:resultmatrixvalueId, :drillresultMetrixId, :drillresultmetrixRow, :drillresultmetrixCol, :drillresultmetrixValue)", withParameterDictionary : Data as! [AnyHashable: Any]);
                
                print("InsertData : \(isInserted))")
                
            }
        }
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
        
//        for i in 0 ..< ResultMetrixDetail.count
//        {
//            
//            let DrillResultMetrixID = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "drillResultMetrixId") as! String
//            
//            let shot_id = ModelManager.instance.get_shot_id((ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "drillId") as! String)
//            
//            let no_of_shot = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "Equivalent_Value") as! String
//            
//            ModelManager.instance.calculate_result(DrillResultMetrixID as! String,total_result: no_of_shot,shottype: shot_id)
//            
//        }
        
        
    }
    
    
    func Insert_student_ResultMetrix1(_ ResultMetrixDetail: NSMutableArray,userId : String)
    {
        print("this is new")
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        print(" \(ResultMetrixDetail)")
        
        for i in 0 ..< ResultMetrixDetail.count 
        {
            
            let DrillResultMetrixID = (ResultMetrixDetail.object(at: i) as! NSDictionary).value(forKey: "drillResultMetrixId") as! String
            print(DrillResultMetrixID)
            //let userId: AnyObject? = ResultMetrixDetail.objectAtIndex(i).valueForKey("userId")
            let DrillID = (ResultMetrixDetail.object(at: i) as! NSDictionary).value(forKey: "drillId") as! String
            let Userid = (ResultMetrixDetail.object(at: i) as! NSDictionary).value(forKey: "userId") as! String
            
            
            let PlanID = (ResultMetrixDetail.object(at: i) as! NSDictionary).value(forKey: "planId") as! String
            
            let drillPlanTransactionId  = (ResultMetrixDetail.object(at: i) as! NSDictionary).value(forKey: "drillPlanTransactionId") as! String
            let no_of_shot = (ResultMetrixDetail.object(at: i) as! NSDictionary).value(forKey: "Equivalent_Value") as! String
            
            let DrillResultTime = (ResultMetrixDetail.object(at: i) as! NSDictionary).value(forKey: "drillResultTime") as! String
            let result_val = "0"

            
            
            let Data : NSMutableDictionary = NSMutableDictionary()
            Data.setValue(DrillResultMetrixID, forKey: "drillResultMetrixid")
            Data.setValue(Userid, forKey: "userId")
            Data.setValue(DrillID, forKey: "drillId")
            Data.setValue(PlanID, forKey: "planId")
            Data.setValue((ResultMetrixDetail.object(at: i) as! NSDictionary).value(forKey: "comment") as! String, forKey: "comment")
            Data.setValue(no_of_shot, forKey: "totalResult")
            Data.setValue(DrillResultTime, forKey: "drillresultTime")
            Data.setValue(drillPlanTransactionId, forKey: "drillPlanTransactionId")
            Data.setValue(result_val, forKey: "result_val")
            
            print("\(Data)")
            
            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Result_Metrix(drillResultMetrixid, userId,drillId,planId,comment,totalResult,drillresultTime,drillPlanTransactionId,result_val) VALUES (:drillResultMetrixid, :userId, :drillId, :planId, :comment, :totalResult, :drillresultTime,:drillPlanTransactionId,:result_val)", withParameterDictionary : Data as! [AnyHashable: Any]);
            print("InsertData : \(isInserted))")
            
            var newDataArray : NSMutableArray = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "studentResultValue") as! NSMutableArray
            
            print(newDataArray);
            
            for i in 0 ..< newDataArray.count 
            {
                
                let resultmatrixvalueId = (newDataArray.object(at: i) as! NSDictionary).value(forKey: "resultMatrixValuesId") as! String
                let drillresultMetrixId = DrillResultMetrixID
                let drillresultmetrixRow = (newDataArray.object(at: i) as! NSDictionary).value(forKey: "drillResultMetrixRow") as! String
                let drillresultmetrixCol = (newDataArray.object(at: i) as! NSDictionary).value(forKey: "drillResultMetrixCol") as! String
                let drillresultmetrixValue = (newDataArray.object(at: i) as! NSDictionary).value(forKey: "drillResultMetrixValue") as! String
                
                let Data : NSMutableDictionary = NSMutableDictionary()
                Data.setValue(resultmatrixvalueId, forKey: "resultmatrixvalueId")
                Data.setValue(drillresultMetrixId, forKey: "drillresultMetrixId")
                Data.setValue(drillresultmetrixRow, forKey: "drillresultmetrixRow")
                Data.setValue(drillresultmetrixCol, forKey: "drillresultmetrixCol")
                Data.setValue(drillresultmetrixValue, forKey: "drillresultmetrixValue")
                
                let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Drill_Result_matrixValue VALUES (:resultmatrixvalueId, :drillresultMetrixId, :drillresultmetrixRow, :drillresultmetrixCol, :drillresultmetrixValue)", withParameterDictionary : Data as! [AnyHashable: Any]);
                
                print("InsertData : \(isInserted))")
            }
            
        }
        
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
        
        
        
//        for i in 0 ..< ResultMetrixDetail.count 
//        {
//            
//            let DrillResultMetrixID = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "drillResultMetrixId") as! String
//            
//            
//            let no_of_shot = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "Equivalent_Value") as! String
//            
//            
//            let shot_id = ModelManager.instance.get_shot_id((ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "drillId") as! String)
//            
//            
//            ModelManager.instance.calculate_result(DrillResultMetrixID as! String,total_result: no_of_shot,shottype: shot_id)
//            
//        }
        
    }
    
    
    func Insert_ResultMetrix1(_ ResultMetrixDetail: NSMutableArray,userId : String)
    {
        print("this is new")
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        
        print(" \(ResultMetrixDetail)")
        
        for i in 0 ..< ResultMetrixDetail.count 
        {
            
            let DrillResultMetrixID = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "drillResultMetrixId")
            //let userId: AnyObject? = ResultMetrixDetail.objectAtIndex(i).valueForKey("userId")
            let DrillID = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "drillId")
            let Userid = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "userId")
            
            let PlanID = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "planId")
            let drillPlanTransactionId  = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "drillPlanTransactionId") as! String
            let totalResult = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "totalResult") as! String
            let currentRepetation = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "actual_repetation") as! String
            
            
            let DrillResultTime = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "drillResultTime")
            let result = Int(Float((ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "result_value") as! String)!)
            print(DrillResultTime!)
            
            
            let Data : NSMutableDictionary = NSMutableDictionary()
            Data.setValue(DrillResultMetrixID, forKey: "drillResultMetrixid")
            Data.setValue(userId, forKey: "userId")
            Data.setValue(DrillID, forKey: "drillId")
            Data.setValue(PlanID, forKey: "planId")
            Data.setValue((ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "comment") as! String, forKey: "comment")
            Data.setValue(totalResult, forKey: "totalResult")
            Data.setValue(DrillResultTime, forKey: "drillresultTime")
            Data.setValue(drillPlanTransactionId, forKey: "drillPlanTransactionId")
            Data.setValue(String(result), forKey: "result")
            Data.setValue(currentRepetation, forKey: "repetation")
            
            print("\(Data)")
            
            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Result_Metrix(drillResultMetrixid, userId,drillId,planId,comment,totalResult,drillresultTime,drillPlanTransactionId,result_val,repetation) VALUES (:drillResultMetrixid, :userId, :drillId, :planId, :comment, :totalResult, :drillresultTime,:drillPlanTransactionId,:result,:repetation)", withParameterDictionary : Data as! [AnyHashable: Any]);
            print("InsertData : \(isInserted))")
            
            var newDataArray : NSMutableArray = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "ownPlanResultValue") as! NSMutableArray
            
            // ModelManager.instance.Insert_Result_Metrix_Value(newDataArray, DrillresultmetrixID: DrillResultMetrixID!)
            
            print(newDataArray);
            
            for i in 0 ..< newDataArray.count 
            {
                
                let resultmatrixvalueId = (newDataArray.object(at: i) as AnyObject).value(forKey: "resultMatrixValuesId")
                let drillresultMetrixId = DrillResultMetrixID!
                let drillresultmetrixRow = (newDataArray.object(at: i) as AnyObject).value(forKey: "drillResultMetrixRow")
                let drillresultmetrixCol = (newDataArray.object(at: i) as AnyObject).value(forKey: "drillResultMetrixCol")
                let drillresultmetrixValue = (newDataArray.object(at: i) as AnyObject).value(forKey: "drillResultMetrixValue")
                
                let Data : NSMutableDictionary = NSMutableDictionary()
                Data.setValue(resultmatrixvalueId, forKey: "resultmatrixvalueId")
                Data.setValue(drillresultMetrixId, forKey: "drillresultMetrixId")
                Data.setValue(drillresultmetrixRow, forKey: "drillresultmetrixRow")
                Data.setValue(drillresultmetrixCol, forKey: "drillresultmetrixCol")
                Data.setValue(drillresultmetrixValue, forKey: "drillresultmetrixValue")
                
                let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Drill_Result_matrixValue VALUES (:resultmatrixvalueId, :drillresultMetrixId, :drillresultmetrixRow, :drillresultmetrixCol, :drillresultmetrixValue)", withParameterDictionary : Data as! [AnyHashable: Any]);
                
                print("InsertData : \(isInserted))")
                
                
            }
            
        }
        
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
        
        
        
//        for i in 0 ..< ResultMetrixDetail.count 
//        {
//            
//            let DrillResultMetrixID = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "drillResultMetrixId") as! String
//            
//            let no_of_shot = (ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "Equivalent_Value") as! String
//            
//            let shot_id = ModelManager.instance.get_shot_id((ResultMetrixDetail.object(at: i) as AnyObject).value(forKey: "drillId") as! String)
//            
//            ModelManager.instance.calculate_result(DrillResultMetrixID ,total_result: no_of_shot,shottype: shot_id)
//        }
        
    }
    

    
    func get_drillcolor(_ drillid:String) -> String
    {
        
        sharedInstance.database!.open()
        
        // sharedInstance.database?.beginTransaction()
        
       
        var colorid = ""
        
        var querySQL = "select color_id from Drill_Info DI inner join  Drill_category_master DM on DM.category_id = DI.category_id where DI.drill_id = \(drillid)"
        
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        while resultSet?.next() == true
        {
            
            
           colorid = resultSet!.string(forColumn: "color_id")
            
            
        }
        
        
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
        return colorid
        
        
    }
    
    
    
    
    func get_drillinfo_byid(_ drillid:String) -> NSDictionary
    {
        
        sharedInstance.database!.open()
        
        // sharedInstance.database?.beginTransaction()
        
         let DicObj:NSMutableDictionary = NSMutableDictionary()
let querySQL = "select metrix_id,title,no_of_shots,package_name,hundred_percent_equi_value,estimat_time,abstract_description,long_description,main_category_name,diffculty_type_id,focus_type_name,purpose_type_name,DM.color_id,category_name from Drill_Info DI inner join focus_Master FM on FM.focus_type_id = DI.focus_type_id inner join Purpose_type_master PM on PM.purpose_type_id = DI.purpose_type_id inner join Drill_category_master DM on DM.category_id = DI.category_id inner join Drill_package DP on  DM.drill_package_id =  DP.drill_package_id inner join Drill_main_category_master DMCM on DMCM.main_category_id = DP.main_category_id where DI.drill_id = \(drillid)"
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        while resultSet?.next() == true
        {
            
            DicObj.setValue(resultSet!.string(forColumn: "title"), forKey: "title")
            DicObj.setValue(resultSet!.string(forColumn: "comment"), forKey: "comment")
            DicObj.setValue(resultSet!.string(forColumn: "no_of_shots"), forKey: "no_of_shots")
            DicObj.setValue(resultSet!.string(forColumn: "estimat_time"), forKey: "estimat_time")
            DicObj.setValue(resultSet!.string(forColumn: "long_description"), forKey: "long_description")
            DicObj.setValue(resultSet!.string(forColumn: "abstract_description"), forKey: "abstract_description")
            DicObj.setValue(resultSet!.string(forColumn: "hundred_percent_equi_value"), forKey: "hundred_percent_equi_value")
            DicObj.setValue(resultSet!.string(forColumn: "diffculty_type_id"), forKey: "diffculty_type_id")
            DicObj.setValue(resultSet!.string(forColumn: "focus_type_name"), forKey: "focus_type_name")
            DicObj.setValue(resultSet!.string(forColumn: "purpose_type_name"), forKey: "purpose_type_name")
            DicObj.setValue(resultSet!.string(forColumn: "color_id"), forKey: "color_id")
            
            DicObj.setValue(resultSet!.string(forColumn: "metrix_id"), forKey: "metrix_id")
            
            DicObj.setValue(resultSet!.string(forColumn: "package_name"), forKey: "package_name")
            
            DicObj.setValue(resultSet!.string(forColumn: "main_category_name"), forKey: "main_category_name")
            
            DicObj.setValue(resultSet!.string(forColumn: "category_name"), forKey: "category_name")
            
        }
        
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
        return DicObj
    }
    
    
    func get_result_by_shot(_ identifier : Int,userid: String,filterarray : NSMutableArray)  -> NSMutableArray
    {
        var filterarray = filterarray
        
        let result_arr = NSMutableArray()
        
        sharedInstance.database!.open()
        
        // sharedInstance.database?.beginTransaction()
        
        var querySQL = ""
        
        
        if filterarray.count == 0
        {
        if identifier == 1
            {
                querySQL  = "select drillresultMetrixId,drill_id,result_val,comment,drillPlanTransactionId,category_name,color_id,title,drillResultTime,estimat_time,hundred_percent_equi_value,no_of_shots  from Result_Metrix RM inner join drill_Info DI on RM.drillId = DI.drill_id inner join Drill_category_master DC on DC.category_id = DI.category_id where DC.color_id = 1  AND RM.userId = \(userid)"
                
            }
            else if identifier == 2
            {
                querySQL  = "select drillresultMetrixId,drill_id,result_val,comment,drillPlanTransactionId,category_name,color_id,title,drillResultTime,estimat_time,hundred_percent_equi_value,no_of_shots  from Result_Metrix RM inner join drill_Info DI on RM.drillId = DI.drill_id inner join Drill_category_master DC on DC.category_id = DI.category_id where DC.color_id = 2 AND RM.userId = \(userid)"
            }
            else
            {
                querySQL  = "select drillresultMetrixId,drill_id,result_val,comment,drillPlanTransactionId,category_name,color_id,title,drillResultTime,estimat_time,hundred_percent_equi_value,no_of_shots  from Result_Metrix RM inner join drill_Info DI on RM.drillId = DI.drill_id inner join Drill_category_master DC on DC.category_id = DI.category_id where (DC.color_id = 3 or DC.color_id = 4 or DC.color_id = 5 or DC.color_id = 6 or DC.color_id = 7 or DC.color_id = 8 or DC.color_id = 9) AND RM.userId = \(userid)"
            }
            //        ["All","Putt","Short Game","Long Game"]
        }
        else
        {
            
            if identifier == 1
            {
                querySQL  = "select drillresultMetrixId,drill_id,result_val,comment,drillPlanTransactionId,category_name,color_id,title,drillResultTime,estimat_time,hundred_percent_equi_value,no_of_shots  from Result_Metrix RM inner join drill_Info DI on RM.drillId = DI.drill_id inner join Drill_category_master DC on DC.category_id = DI.category_id where DC.color_id = 1   AND RM.userId = \(userid) AND ("
            }
            else if identifier == 2
            {
                querySQL  = "select drillresultMetrixId,drill_id,result_val,comment,drillPlanTransactionId,category_name,color_id,title,drillResultTime,estimat_time,hundred_percent_equi_value,no_of_shots  from Result_Metrix RM inner join drill_Info DI on RM.drillId = DI.drill_id inner join Drill_category_master DC on DC.category_id = DI.category_id where DC.color_id = 2 AND RM.userId = \(userid) AND ("
            }
            else
            {
                querySQL  = "select drillresultMetrixId,drill_id,result_val,comment,drillPlanTransactionId,category_name,color_id,title,drillResultTime,estimat_time,hundred_percent_equi_value,no_of_shots  from Result_Metrix RM inner join drill_Info DI on RM.drillId = DI.drill_id inner join Drill_category_master DC on DC.category_id = DI.category_id where (DC.color_id = 3 or DC.color_id = 4 or DC.color_id = 5 or DC.color_id = 6 or DC.color_id = 7 or DC.color_id = 8 or DC.color_id = 9) AND RM.userId = \(userid) AND ("
            }
            
            
            
            
            
            //  ["All","Week","4 Week","12 Week"]
            
            for i in 0 ..< filterarray.count 
            {
                
                switch filterarray[i] as! String {
                case "Week":
                    
                    querySQL = querySQL +  " RM.drillResultTime BETWEEN datetime('now', '-7 days') AND datetime('now', 'localtime') OR"
                    break
                    
                case "4 Week":
                    
                    querySQL = querySQL + " RM.drillResultTime BETWEEN datetime('now', '-30 days') AND datetime('now', 'localtime') OR"
                    break
                    
                case "12 Week":
                    
                    querySQL = querySQL + " RM.drillResultTime BETWEEN datetime('now', '-90 days') AND datetime('now', 'localtime') OR"
                    break
                default:
                    
                    querySQL = querySQL +  " RM.drillResultTime BETWEEN datetime('now', '-7 days') AND datetime('now', 'localtime') OR" + " RM.drillResultTime BETWEEN datetime('now', '-30 days') AND datetime('now', 'localtime') OR" + " RM.drillResultTime BETWEEN datetime('now', '-90 days') AND datetime('now', 'localtime') OR"
                     break
                    
                }
            }
            querySQL.remove(at: querySQL.characters.index(before: querySQL.endIndex))
            querySQL.remove(at: querySQL.characters.index(before: querySQL.endIndex))
            querySQL = querySQL + ")"
        }
        
        sharedInstanceQueue.databaseQueue!.inDeferredTransaction { database, rollback in
            do
            {
                let resultSet: FMResultSet! = try sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
                while resultSet?.next() == true
                {
                    
                    let DicObj:NSMutableDictionary = NSMutableDictionary()
                    print(resultSet!.string(forColumn: "drill_id"))
                    DicObj.setValue(resultSet!.string(forColumn: "drill_id"), forKey: "drill_id")
                    DicObj.setValue(resultSet!.string(forColumn: "estimat_time"), forKey: "estimat_time")
                    DicObj.setValue(resultSet!.string(forColumn: "drillResultTime"), forKey: "drillResultTime")
                    DicObj.setValue(resultSet!.string(forColumn: "no_of_shots"), forKey: "no_of_shots")
                    DicObj.setValue(resultSet!.string(forColumn: "category_name"), forKey: "category_name")
                    DicObj.setValue(resultSet!.string(forColumn: "color_id"), forKey: "color_id")
                    DicObj.setValue(resultSet!.string(forColumn: "title"), forKey: "title")
                    //            drillresultMetrixId
                    DicObj.setValue(resultSet!.string(forColumn: "result_val"), forKey: "result_val")
                    DicObj.setValue(resultSet!.string(forColumn: "drillresultMetrixId"), forKey: "drillresultMetrixId")
                    
                    //            comment
                    DicObj.setValue(resultSet!.string(forColumn: "comment"), forKey: "comment")
                    DicObj.setValue(resultSet!.string(forColumn: "drillPlanTransactionId"), forKey: "drillPlanTransactionId")
                    result_arr.add(DicObj.mutableCopy())
                    
                }
            }
            catch
            {
                rollback!.pointee = true
                print(error)
            }
        }
        
        
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        return result_arr;
        
    }
    
    func get_unique_categoryname() -> NSMutableArray
    {
        
        let result_array = NSMutableArray()
        sharedInstance.database!.open()
        
        // sharedInstance.database?.beginTransaction()
        
         var querySQL = "select DISTINCT category_name from Drill_category_master"
        
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        while resultSet?.next() == true
        {
            result_array.add(resultSet!.string(forColumn: "category_name"))
        }

         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
        return result_array;
        
    }
    
    // Hardik Change Start
    
    func getNoOfDrill(_ planid:String) -> NSMutableArray
    {
        // Unplayed Category Count
        var querySQL = ""
        let result_arr = NSMutableArray()
        
        sharedInstance.database!.open()
        
        // sharedInstance.database?.beginTransaction()
        
        querySQL = "SELECT drillResultMetrixId FROM Result_metrix where planId= \(planid)"
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        while resultSet?.next() == true
        {
            let DicObj:NSMutableDictionary = NSMutableDictionary()
            DicObj.setValue(resultSet!.string(forColumn: "drillResultMetrixId"), forKey: "drillResultMetrixId")
            result_arr.add(DicObj.mutableCopy())
        }
        
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
        return result_arr;
        
    }

    
    func getactivePlanTimeShots(_ planid:String) -> NSMutableDictionary
    {
        
        var querySQL = ""
        let result_arr = NSMutableDictionary()
        
        sharedInstance.database!.open()
        
        // sharedInstance.database?.beginTransaction()
        
        querySQL = "select count(pl.repetation) as totalDrills, pl.repetation,sum(Drill_Info.no_of_shots) as totalshots, sum(strftime('%s', Drill_Info.estimat_time) - strftime('%s', '00:00:00')) as totalseconds  FROM Drill_Info   INNER JOIN Drill_plan_transaction  ON Drill_Info.drill_id=Drill_plan_transaction.drill_Id  inner join Plan pl ON pl.plan_id= \(planid) WHERE Drill_plan_transaction.plan_Id = \(planid)"
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        while resultSet?.next() == true
        {
            if(resultSet!.string(forColumn: "totalDrills") == nil)
            {
                result_arr.setValue("0", forKey: "totalDrills")
            }
            else{
                result_arr.setValue(resultSet!.string(forColumn: "totalDrills"), forKey: "totalDrills")
            }
            if(resultSet!.string(forColumn: "repetation") == nil)
            {
                result_arr.setValue("0", forKey: "repetation")
            }
            else{
                result_arr.setValue(resultSet!.string(forColumn: "repetation"), forKey: "repetation")
            }
            if(resultSet!.string(forColumn: "totalseconds") == nil)
            {
                result_arr.setValue("0", forKey: "totalseconds")
            }
            else{
                result_arr.setValue(resultSet!.string(forColumn: "totalseconds"), forKey: "totalseconds")
            }
            if(resultSet!.string(forColumn: "totalshots") == nil)
            {
                result_arr.setValue("0", forKey: "no_of_shots")
            }
            else{
                result_arr.setValue(resultSet!.string(forColumn: "totalshots"), forKey: "no_of_shots")
            }
        }
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
        return result_arr;
    }
    
    
    func getactivePlanPlayedCategoryCount(_ planid:String) -> NSMutableArray
    {
        
        var querySQL = ""
        let result_arr = NSMutableArray()
        
        sharedInstance.database!.open()
        
        // sharedInstance.database?.beginTransaction()
        
        querySQL = "SELECT Drill_main_category_master.main_category_id ,count (Drill_main_category_master.main_category_id) as count FROM Drill_main_category_master JOIN Drill_package ON (Drill_main_category_master.main_category_id = Drill_package.main_category_id) JOIN Drill_category_master ON  (Drill_category_master.drill_package_id = Drill_package.drill_package_id) JOIN Drill_Info  ON (Drill_Info.category_id = Drill_category_master.category_id) JOIN Result_Metrix ON (Result_Metrix.drillId = Drill_Info.drill_id) JOIN Plan ON (Plan.plan_id = Result_Metrix.planId) where Plan.plan_id= \(planid) group by Drill_main_category_master.main_category_id"
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        while resultSet?.next() == true
        {
            let DicObj:NSMutableDictionary = NSMutableDictionary()
            DicObj.setValue(resultSet!.string(forColumn: "main_category_id"), forKey: "main_category_id")
            DicObj.setValue(resultSet!.string(forColumn: "count") as String, forKey: "count")
            
            result_arr.add(DicObj.mutableCopy())
        }
        
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        return result_arr;
        
    }
    
    func getactivePlanCategoryCount(_ planid:String) -> NSMutableArray
    {
        // Unplayed Category Count
        var querySQL = ""
        let result_arr = NSMutableArray()
        
        sharedInstance.database!.open()
        
        // sharedInstance.database?.beginTransaction()
        
        querySQL = "SELECT Drill_main_category_master.main_category_id ,count(Drill_main_category_master.main_category_id) as count FROM Drill_main_category_master JOIN Drill_package ON (Drill_main_category_master.main_category_id = Drill_package.main_category_id) JOIN Drill_category_master ON (Drill_category_master.drill_package_id = Drill_package.drill_package_id) JOIN Drill_Info ON (Drill_Info.category_id = Drill_category_master.category_id) JOIN Drill_plan_transaction ON (Drill_plan_transaction.drill_Id = Drill_Info.drill_id) JOIN Plan ON (Plan.plan_id = Drill_plan_transaction.plan_Id) where Plan.plan_id= \(planid) group by Drill_main_category_master.main_category_id"
        
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        while resultSet?.next() == true
        {
            let DicObj:NSMutableDictionary = NSMutableDictionary()
            DicObj.setValue(resultSet!.string(forColumn: "main_category_id"), forKey: "main_category_id")
            DicObj.setValue(String(resultSet!.string(forColumn: "count")), forKey: "count")
            
            result_arr.add(DicObj.mutableCopy())
        }
        
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        return result_arr;
        
    }
    
    func getactivePlanPlayedShotCount(_ planid:String , userId:String) -> NSMutableArray
    {
        
        var querySQL = ""
        let result_arr = NSMutableArray()
        
        sharedInstance.database!.open()
        
        // sharedInstance.database?.beginTransaction()
        
        querySQL = "SELECT Drill_category_master.color_id, count(Drill_category_master.color_id) as count FROM Drill_category_master JOIN Drill_Info ON (Drill_Info.category_id = Drill_category_master.category_id) JOIN Result_Metrix ON (Result_Metrix.drillId = Drill_Info.drill_id) JOIN Plan ON (Plan.plan_id = Result_Metrix.planId) where Plan.plan_id= \(planid) and Result_Metrix.userid= \(userId) group by Drill_category_master.color_id"
        
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        while resultSet?.next() == true
        {
            let DicObj:NSMutableDictionary = NSMutableDictionary()
            DicObj.setValue(resultSet!.string(forColumn: "color_id"), forKey: "color_id")
            DicObj.setValue(resultSet!.string(forColumn: "count") as String, forKey: "count")
            
            result_arr.add(DicObj.mutableCopy())
        }
        
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
        return result_arr;
        
    }
    
    func getactivePlanShotCount(_ planid:String) -> NSMutableArray
    {
        // Unplayed Shot Count
        var querySQL = ""
        let result_arr = NSMutableArray()
        
        sharedInstance.database!.open()
        
        // sharedInstance.database?.beginTransaction()
        
        querySQL = "SELECT Drill_category_master.color_id, count(Drill_category_master.color_id) as count FROM Drill_category_master JOIN Drill_Info ON (Drill_Info.category_id = Drill_category_master.category_id) JOIN Drill_plan_transaction ON (Drill_plan_transaction.drill_Id = Drill_Info.drill_id) JOIN Plan ON (Plan.plan_id = Drill_plan_transaction.plan_Id) where Plan.plan_id=\(planid) group by Drill_category_master.color_id"
        
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        while resultSet?.next() == true
        {
            let DicObj:NSMutableDictionary = NSMutableDictionary()
            DicObj.setValue(resultSet!.string(forColumn: "color_id"), forKey: "color_id")
            DicObj.setValue(resultSet!.string(forColumn: "count") as String, forKey: "count")
            
            result_arr.add(DicObj.mutableCopy())
        }
        
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        return result_arr;
        
    }
    
    
    func getactiveplan_result(_ planid:String,filter:String) -> NSMutableDictionary
    {
        
        var querySQL = ""
        var result_arr = NSMutableDictionary()
        
        sharedInstance.database!.open()
        
        // sharedInstance.database?.beginTransaction()
        
        querySQL = "select sum(strftime('%s',estimat_time) -strftime('%s', '00:00:00')) as totalseconds,sum(no_of_shots) as totalshots from Result_Metrix RM inner join drill_Info DI on RM.drillId = DI.drill_id where  RM.drillResultTime BETWEEN datetime('now', '-\(filter) days') AND datetime('now', 'localtime')  AND RM.planid = \(planid)"
        
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        while resultSet?.next() == true
        {
            
            result_arr.setValue(resultSet!.string(forColumn: "totalseconds"), forKey: "totalseconds")
            result_arr.setValue(resultSet!.string(forColumn: "totalshots"), forKey: "no_of_shots")
            
            
        }
        
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        return result_arr;
        
        
    }
    
    func getResultByTime(_ userID:String,days:String,filterarray:NSMutableArray) -> NSMutableArray
    {
        // Result By Time And Filter By Color
        var querySQL = ""
        var result_arr = NSMutableArray()
        
        sharedInstance.database!.open()
        
        // sharedInstance.database?.beginTransaction()
        
        if(filterarray.count==0)
        {
            querySQL = "select group_concat(color_code) as color_code,group_concat(drillresultMetrixId) as drillresultMetrixId,group_concat(drillId) as drillId,group_concat(drillPlanTransactionId) as drillPlanTransactionId,avg(RM.result_val) as result_value,group_concat(RM.repetation) as repetation ,drillResultTime,sum(strftime('%s',estimat_time) -strftime('%s', '00:00:00')) as totalseconds,sum(no_of_shots) as no_of_shots  from Result_Metrix RM inner join Drill_Info DI on RM.drillId = DI.drill_id inner join Drill_category_master DC on DC.category_id = DI.category_id inner join Drill_color_master DMC on DMC.color_id = DC.color_id where (RM.drillResultTime BETWEEN datetime('now', '-\(days) days') AND datetime('now', 'localtime')) AND RM.userId = \(userID)"
            
        }
        else{
            querySQL = "select group_concat(color_code) as color_code,group_concat(drillresultMetrixId) as drillresultMetrixId,group_concat(drillId) as drillId,group_concat(drillPlanTransactionId) as drillPlanTransactionId,avg(RM.result_val) as result_value,group_concat(RM.repetation) as repetation ,drillResultTime,sum(strftime('%s',estimat_time) -strftime('%s', '00:00:00')) as totalseconds,sum(no_of_shots) as no_of_shots  from Result_Metrix RM inner join Drill_Info DI on RM.drillId = DI.drill_id inner join Drill_category_master DC on DC.category_id = DI.category_id inner join Drill_color_master DMC on DMC.color_id = DC.color_id where (RM.drillResultTime BETWEEN datetime('now', '-\(days) days') AND datetime('now', 'localtime')) AND RM.userId = \(userID) AND"
            
            for i in 0 ..< filterarray.count
            {
                
                switch filterarray[i] as! String {
                case "Putt Game":
                    
                    querySQL = querySQL + " DC.color_id =  \(1) OR"
                    break
                    
                case "Short Game":
                    
                    querySQL = querySQL + " DC.color_id =  \(2) OR"
                    break
                    
                case "Long Game":
                    
                    querySQL = querySQL + " DC.color_id =  \(3) OR DC.color_id = 4 or DC.color_id = 5 or DC.color_id = 6 or DC.color_id = 7 or DC.color_id = 8 or DC.color_id = 9 OR"
                    //                    (DC.color_id = 3 or DC.color_id = 4 or DC.color_id = 5 or DC.color_id = 6 or DC.color_id = 7 or DC.color_id = 8 or DC.color_id = 9)
                    break
                default:
                    
                    querySQL = querySQL + "DC.color_id =  \(1) OR" + " DC.color_id =  \(2) OR" + " DC.color_id =  \(3) OR DC.color_id = 4 or DC.color_id = 5 or DC.color_id = 6 or DC.color_id = 7 or DC.color_id = 8 or DC.color_id = 9 OR"
                    break
                    
                }
                
                
            }
            
            
            querySQL.remove(at: querySQL.characters.index(before: querySQL.endIndex))
            querySQL.remove(at: querySQL.characters.index(before: querySQL.endIndex))
        }
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        while resultSet?.next() == true
        {
            let dictTemp = NSMutableDictionary()
            dictTemp.setValue(resultSet!.string(forColumn: "color_code"), forKey: "color_code")
            dictTemp.setValue(resultSet!.string(forColumn: "drillresultMetrixId"), forKey: "drillresultMetrixId")
            dictTemp.setValue(resultSet!.string(forColumn: "drillId"), forKey: "drillId")
            dictTemp.setValue(resultSet!.string(forColumn: "drillPlanTransactionId"), forKey: "drillPlanTransactionId")
            dictTemp.setValue(resultSet!.string(forColumn: "result_value"), forKey: "result_value")
            dictTemp.setValue(resultSet!.string(forColumn: "repetation"), forKey: "repetation")
            dictTemp.setValue(resultSet!.string(forColumn: "drillResultTime"), forKey: "drillResultTime")
            dictTemp.setValue(resultSet!.string(forColumn: "totalseconds"), forKey: "totalseconds")
            dictTemp.setValue(resultSet!.string(forColumn: "no_of_shots"), forKey: "no_of_shots")
            if(dictTemp.count > 0)
            {
                result_arr.add(dictTemp)
            }
            
        }
        
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        return result_arr;
        
        
    }
    
    func getResultByShot(_ shotType : Int,userid: String,filterarray : NSMutableArray)  -> NSMutableArray
    {
        var filterarray = filterarray
        
        
        
        let result_arr = NSMutableArray()
        
        sharedInstance.database!.open()
        
        // sharedInstance.database?.beginTransaction()
        
        var querySQL = ""
        
        if filterarray.count == 0
        {
            if shotType == 1
            {
                querySQL  = "select group_concat(color_code) as color_code,group_concat(drillresultMetrixId) as drillresultMetrixId,group_concat(drillId) as drillId,group_concat(drillPlanTransactionId) as drillPlanTransactionId,avg(RM.result_val) as result_value,group_concat(RM.repetation) as repetation ,drillResultTime,sum(strftime('%s',estimat_time) -strftime('%s', '00:00:00')) as totalseconds,sum(no_of_shots) as no_of_shots  from Result_Metrix RM inner join Drill_Info DI on RM.drillId = DI.drill_id inner join Drill_category_master DC on DC.category_id = DI.category_id    inner  join Drill_color_master DMC on DMC.color_id = DC.color_id where  DC.color_id = 1  AND RM.userId = \(userid)"
                
            }
            else if shotType == 2
            {
                querySQL  = "select group_concat(color_code) as color_code,group_concat(drillresultMetrixId) as drillresultMetrixId,group_concat(drillId) as drillId,group_concat(drillPlanTransactionId) as drillPlanTransactionId,avg(RM.result_val) as result_value,group_concat(RM.repetation) as repetation ,drillResultTime,sum(strftime('%s',estimat_time) -strftime('%s', '00:00:00')) as totalseconds,sum(no_of_shots) as no_of_shots  from Result_Metrix RM inner join Drill_Info DI on RM.drillId = DI.drill_id inner join Drill_category_master DC on DC.category_id = DI.category_id    inner  join Drill_color_master DMC on DMC.color_id = DC.color_id where  DC.color_id = 2  AND RM.userId = \(userid)"
            }
            else
            {
                querySQL  = "select group_concat(color_code) as color_code,group_concat(drillresultMetrixId) as drillresultMetrixId,group_concat(drillId) as drillId,group_concat(drillPlanTransactionId) as drillPlanTransactionId,avg(RM.result_val) as result_value,group_concat(RM.repetation) as repetation ,drillResultTime,sum(strftime('%s',estimat_time) -strftime('%s', '00:00:00')) as totalseconds,sum(no_of_shots) as no_of_shots  from Result_Metrix RM inner join Drill_Info DI on RM.drillId = DI.drill_id inner join Drill_category_master DC on DC.category_id = DI.category_id    inner  join Drill_color_master DMC on DMC.color_id = DC.color_id where  (DC.color_id = 3 or DC.color_id = 4 or DC.color_id = 5 or DC.color_id = 6 or DC.color_id = 7 or DC.color_id = 8 or DC.color_id = 9)  AND RM.userId = \(userid)"
            }
            //        ["All","Putt","Short Game","Long Game"]
        }
        else
        {
            
            if shotType == 1
            {
                querySQL  = "select group_concat(color_code) as color_code,group_concat(drillresultMetrixId) as drillresultMetrixId,group_concat(drillId) as drillId,group_concat(drillPlanTransactionId) as drillPlanTransactionId,avg(RM.result_val) as result_value,group_concat(RM.repetation) as repetation ,drillResultTime,sum(strftime('%s',estimat_time) -strftime('%s', '00:00:00')) as totalseconds,sum(no_of_shots) as no_of_shots  from Result_Metrix RM inner join Drill_Info DI on RM.drillId = DI.drill_id inner join Drill_category_master DC on DC.category_id = DI.category_id    inner  join Drill_color_master DMC on DMC.color_id = DC.color_id where  DC.color_id = 1  AND RM.userId = \(userid) AND ("
            }
            else if shotType == 2
            {
                querySQL  = "select group_concat(color_code) as color_code,group_concat(drillresultMetrixId) as drillresultMetrixId,group_concat(drillId) as drillId,group_concat(drillPlanTransactionId) as drillPlanTransactionId,avg(RM.result_val) as result_value,group_concat(RM.repetation) as repetation ,drillResultTime,sum(strftime('%s',estimat_time) -strftime('%s', '00:00:00')) as totalseconds,sum(no_of_shots) as no_of_shots  from Result_Metrix RM inner join Drill_Info DI on RM.drillId = DI.drill_id inner join Drill_category_master DC on DC.category_id = DI.category_id    inner  join Drill_color_master DMC on DMC.color_id = DC.color_id where  DC.color_id = 2  AND RM.userId = \(userid) AND ("
            }
            else
            {
                querySQL  = "select group_concat(color_code) as color_code,group_concat(drillresultMetrixId) as drillresultMetrixId,group_concat(drillId) as drillId,group_concat(drillPlanTransactionId) as drillPlanTransactionId,avg(RM.result_val) as result_value,group_concat(RM.repetation) as repetation ,drillResultTime,sum(strftime('%s',estimat_time) -strftime('%s', '00:00:00')) as totalseconds,sum(no_of_shots) as no_of_shots  from Result_Metrix RM inner join Drill_Info DI on RM.drillId = DI.drill_id inner join Drill_category_master DC on DC.category_id = DI.category_id    inner  join Drill_color_master DMC on DMC.color_id = DC.color_id where  (DC.color_id = 3 or DC.color_id = 4 or DC.color_id = 5 or DC.color_id = 6 or DC.color_id = 7 or DC.color_id = 8 or DC.color_id = 9)  AND RM.userId = \(userid) AND ("
            }
            
            
            //  ["All","Week","4 Week","12 Week"]
            
            for i in 0 ..< filterarray.count
            {
                
                switch filterarray[i] as! String {
                case "Week":
                    
                    querySQL = querySQL +  " RM.drillResultTime BETWEEN datetime('now', '-7 days') AND datetime('now', 'localtime') OR"
                    break
                    
                case "4 Week":
                    
                    querySQL = querySQL + " RM.drillResultTime BETWEEN datetime('now', '-30 days') AND datetime('now', 'localtime') OR"
                    break
                    
                case "12 Week":
                    
                    querySQL = querySQL + " RM.drillResultTime BETWEEN datetime('now', '-90 days') AND datetime('now', 'localtime') OR"
                    break
                default:
                    
                    querySQL = querySQL +  " RM.drillResultTime BETWEEN datetime('now', '-7 days') AND datetime('now', 'localtime') OR" + " RM.drillResultTime BETWEEN datetime('now', '-30 days') AND datetime('now', 'localtime') OR" + " RM.drillResultTime BETWEEN datetime('now', '-90 days') AND datetime('now', 'localtime') OR"
                    break
                    
                }
                
                
                
                
            }
            querySQL.remove(at: querySQL.characters.index(before: querySQL.endIndex))
            querySQL.remove(at: querySQL.characters.index(before: querySQL.endIndex))
            querySQL = querySQL + ")"
        }
        
        
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        while resultSet?.next() == true
        {
            
            let dictTemp:NSMutableDictionary = NSMutableDictionary()
            dictTemp.setValue(resultSet!.string(forColumn: "color_code"), forKey: "color_code")
            dictTemp.setValue(resultSet!.string(forColumn: "drillresultMetrixId"), forKey: "drillresultMetrixId")
            dictTemp.setValue(resultSet!.string(forColumn: "drillId"), forKey: "drillId")
            dictTemp.setValue(resultSet!.string(forColumn: "drillPlanTransactionId"), forKey: "drillPlanTransactionId")
            dictTemp.setValue(resultSet!.string(forColumn: "result_value"), forKey: "result_value")
            dictTemp.setValue(resultSet!.string(forColumn: "repetation"), forKey: "repetation")
            dictTemp.setValue(resultSet!.string(forColumn: "drillResultTime"), forKey: "drillResultTime")
            dictTemp.setValue(resultSet!.string(forColumn: "totalseconds"), forKey: "totalseconds")
            dictTemp.setValue(resultSet!.string(forColumn: "no_of_shots"), forKey: "no_of_shots")
            result_arr.add(dictTemp)
            
        }
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
        return result_arr;
    }
    
    
    // Hardik Change End
    
    
    
    
    func get_result_by_time(_ identifier : Int,userid: String,filterarrays : NSMutableArray)  -> NSMutableArray
    {
        let filterarray = filterarrays
        
        let result_arr = NSMutableArray()
        
        sharedInstance.database!.open()
        
        // sharedInstance.database?.beginTransaction()
        
        var querySQL = ""
        //         var querySQL1 = ""
         if filterarray.count == 0
        {
            
            if identifier == 1
            {
                querySQL  = "select drillresultMetrixId,drill_id,title,drillPlanTransactionId,comment,result_val,drillResultTime,estimat_time,hundred_percent_equi_value,no_of_shots  from Result_Metrix RM inner join drill_Info DI on RM.drillId = DI.drill_id where  RM.drillResultTime BETWEEN datetime('now', '-7 days') AND datetime('now', 'localtime') AND RM.userId = \(userid)"
            }
            else if identifier == 2
            {
                querySQL  = "select drillresultMetrixId,drill_id,title,drillPlanTransactionId,comment,result_val,drillResultTime,estimat_time,hundred_percent_equi_value,no_of_shots  from Result_Metrix RM inner join drill_Info DI on RM.drillId = DI.drill_id where  RM.drillResultTime BETWEEN datetime('now', '-30 days') AND datetime('now', 'localtime') AND RM.userId = \(userid)"
            }
            else
            {
                querySQL  = "select drillresultMetrixId,drill_id,title,drillPlanTransactionId,comment,result_val,drillResultTime,estimat_time,hundred_percent_equi_value,no_of_shots  from Result_Metrix RM inner join drill_Info DI on RM.drillId = DI.drill_id where  RM.drillResultTime BETWEEN datetime('now', '-90 days') AND datetime('now', 'localtime') AND RM.userId = \(userid)"
            }
            //        ["All","Putt","Short Game","Long Game"]
        }
        else
        {
            
            
            if identifier == 1
            {
                querySQL  = "select drillresultMetrixId,drill_id,title,drillPlanTransactionId,comment,result_val,drillResultTime,estimat_time,hundred_percent_equi_value,no_of_shots  from Result_Metrix RM inner join drill_Info DI on RM.drillId = DI.drill_id inner join Drill_category_master DC on DC.category_id = DI.category_id where  RM.drillResultTime BETWEEN datetime('now', '-7 days') AND datetime('now', 'localtime') AND RM.userId = \(userid) AND ("
            }
            else if identifier == 2
            {
                querySQL  = "select drillresultMetrixId,drill_id,title,drillPlanTransactionId,comment,result_val,drillResultTime,estimat_time,hundred_percent_equi_value,no_of_shots  from Result_Metrix RM inner join drill_Info DI on RM.drillId = DI.drill_id inner join Drill_category_master DC on DC.category_id = DI.category_id where  RM.drillResultTime BETWEEN datetime('now', '-30 days') AND datetime('now', 'localtime') AND RM.userId = \(userid) AND ("
            }
            else
            {
                querySQL  = "select drillresultMetrixId,drill_id,title,drillPlanTransactionId,comment,result_val,drillResultTime,estimat_time,hundred_percent_equi_value,no_of_shots  from Result_Metrix RM inner join drill_Info DI on RM.drillId = DI.drill_id inner join Drill_category_master DC on DC.category_id = DI.category_id where  RM.drillResultTime BETWEEN datetime('now', '-90 days') AND datetime('now', 'localtime') AND RM.userId = \(userid) AND ("
            }
    
            for i in 0 ..< filterarray.count 
            {
                
                switch filterarray[i] as! String {
                case "Putt Game":
                    
                    querySQL = querySQL + " DC.color_id =  \(1) OR"
                    break
                    
                case "Short Game":
                    
                    querySQL = querySQL + " DC.color_id =  \(2) OR"
                    break
                    
                case "Long Game":
                    
                    querySQL = querySQL + " DC.color_id =  \(3) OR DC.color_id = 4 or DC.color_id = 5 or DC.color_id = 6 or DC.color_id = 7 or DC.color_id = 8 or DC.color_id = 9 OR"
                    //                    (DC.color_id = 3 or DC.color_id = 4 or DC.color_id = 5 or DC.color_id = 6 or DC.color_id = 7 or DC.color_id = 8 or DC.color_id = 9)
                    break
                default:
                    
                    querySQL = querySQL + "DC.color_id =  \(1) OR" + " DC.color_id =  \(2) OR" + " DC.color_id =  \(3) OR DC.color_id = 4 or DC.color_id = 5 or DC.color_id = 6 or DC.color_id = 7 or DC.color_id = 8 or DC.color_id = 9 OR"
                    break
                    
                }
            }
            
            
            querySQL.remove(at: querySQL.characters.index(before: querySQL.endIndex))
            querySQL.remove(at: querySQL.characters.index(before: querySQL.endIndex))
          //  querySQL = querySQL + ")"
            querySQL = querySQL + ")"
        }
        
//        select drillresultMetrixId,drill_id,title,drillPlanTransactionId,comment,result_val,drillResultTime,estimat_time,hundred_percent_equi_value,no_of_shots  from Result_Metrix RM inner join drill_Info DI on RM.drillId = DI.drill_id inner join Drill_category_master DC on DC.category_id = DI.category_id where  RM.drillResultTime BETWEEN datetime(\'now\', \'-7 days\') AND datetime(\'now\', \'localtime\') AND RM.userId = 440 AND  DC.color_id =  1 OR DC.color_id =  2 OR DC.color_id =  3 OR DC.color_id = 4 or DC.color_id = 5 or DC.color_id = 6 or DC.color_id = 7 or DC.color_id = 8 or DC.color_id = 9 
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        while resultSet?.next() == true
        {
            
            let DicObj:NSMutableDictionary = NSMutableDictionary()
            print(resultSet!.string(forColumn: "drill_id"))
            DicObj.setValue(resultSet!.string(forColumn: "drill_id"), forKey: "drill_id")
            DicObj.setValue(resultSet!.string(forColumn: "estimat_time"), forKey: "estimat_time")
            DicObj.setValue(resultSet!.string(forColumn: "no_of_shots"), forKey: "no_of_shots")
            DicObj.setValue(resultSet!.string(forColumn: "drillResultTime"), forKey: "drillResultTime")
            
            DicObj.setValue(resultSet!.string(forColumn: "title"), forKey: "title")
            DicObj.setValue(resultSet!.string(forColumn: "result_val"), forKey: "result_val")
            DicObj.setValue(resultSet!.string(forColumn: "drillPlanTransactionId"), forKey: "drillPlanTransactionId")
            
            //            comment
            
            DicObj.setValue(resultSet!.string(forColumn: "drillresultMetrixId"), forKey: "drillresultMetrixId")
            
            DicObj.setValue(resultSet!.string(forColumn: "comment"), forKey: "comment")
            result_arr.add(DicObj.mutableCopy())
            
            
        }
        
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        return result_arr;
        
    }
    
    
    func Database_ResultDrill(_ ResultDrill : NSMutableArray, filter : String)
    {
       
        sharedInstance.database!.open()
        
        // sharedInstance.database?.beginTransaction()
        
        let querySQL:String


        if(filter == "All")
        {
        querySQL = NSString(format:"select * from Result_Metrix RM, drill_Info DI, drill_category_master DCM, Drill_package DP, Drill_main_category_master DMCM, drill_color_master DCOLM WHERE RM.drillId = DI.drill_id AND DI.category_id=DCM.category_id AND DP.drill_package_id=DCM.drill_package_id AND DMCM.main_category_id=DP.main_category_id AND DCOLM.color_id=DP.color_id order by DI.drill_id DESC") as String
        }
        else if(filter == "Week"){
            querySQL = NSString(format:"select * from Result_Metrix RM, Drill_Info DI Where RM.drillId = DI.drill_id AND  drillResultTime BETWEEN datetime('now', '-7 days') AND datetime('now', 'localtime')") as String
        }
        else if(filter == "Month")
        {
            querySQL = NSString(format:"select * from Result_Metrix RM, Drill_Info DI Where RM.drillId = DI.drill_id AND  drillResultTime BETWEEN datetime('now', '-30 days') AND datetime('now', 'localtime')") as String
        }
        else
        {
            querySQL = NSString(format:"select * from Result_Metrix RM, Drill_Info DI Where RM.drillId = DI.drill_id AND  drillResultTime BETWEEN datetime('now', '-90 days') AND datetime('now', 'localtime')") as String
        }
    
        print(querySQL)
        

        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        let DrillResultMetrixId: String = "drillresultMetrixId"
        let UserID: String = "userId"
        let DrillID: String = "drillId"
        let PlanID: String = "planId"
        let Comment: String = "comment"
        let Totalresult: String = "totalResult"
        let DrillresultTime: String = "drillResultTime"
        
        
        
        let Drill_ID: String = "drill_id"
        let Drill_Title: String = "title"
        let Drill_Short_DESC: String = "abstract_description"
        let Drill_Long_DESC: String = "long_description"
        let Drill_Est_time: String = "estimat_time"
        let Drill_Equity: String = "hundred_percent_equi_value"
        let Drill_CatID: String = "category_id"
        let Drill_Difficulty_ID: String = "diffculty_type_id"
        let Drill_FocusID: String = "focus_type_id"
        let Drill_ShotID: String = "shot_type_id"
        let Drill_TrainingID: String = "traning_type_id"
        let Drill_PurposeID: String = "purpose_type_id"
        let Drill_SituationID: String = "situation_type_id"
        let Drill_MetrixID: String = "metrix_id"
        
        let CatID: String = "category_id"
        let Drill_Package_ID: String = "drill_package_id"
        let Cat_Name: String = "category_name"
        let Color_ID: String = "color_id"
        let Drill_Package_ID1: String = "drill_package_id"
        let Main_Category_ID: String = "main_category_id"
        let Color_ID1: String = "color_id"
        let Package_Name: String = "package_name"
        let Main_Category_ID1: String = "main_category_id"
        let Main_Category_NAME: String = "main_category_name"
        let Color_ID2: String = "color_id"
        let Color_ID3: String = "color_id"
        let Color_Name: String = "color_name"
        let Color_Code: String = "color_code"
        let NOOFShots: String = "hundred_percent_equi_value"
        let DrillTypeID: String = "drillTypeid"
        
        
        
        if (resultSet != nil) {
            
            while resultSet?.next() == true
            {
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                
                DicObj.setValue(resultSet!.string(forColumn: DrillResultMetrixId), forKey: "DrillResultMetrixId")
                DicObj.setValue(resultSet!.string(forColumn: UserID), forKey: "UserID")
                DicObj.setValue(resultSet!.string(forColumn: DrillID), forKey: "DrillID")
                DicObj.setValue(resultSet!.string(forColumn: PlanID), forKey: "PlanID")
                DicObj.setValue(resultSet!.string(forColumn: Comment), forKey: "Comment")
                DicObj.setValue(resultSet!.string(forColumn: Totalresult), forKey: "Totalresult")
                DicObj.setValue(resultSet!.string(forColumn: DrillresultTime), forKey: "DrillresultTime")
                DicObj.setValue(resultSet!.string(forColumn: Drill_ID), forKey: "Drill_ID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Title), forKey: "Drill_Title")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Short_DESC), forKey: "Drill_Short_DESC")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Long_DESC), forKey: "Drill_Long_DESC")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Est_time), forKey: "Drill_Est_time")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Equity), forKey: "Drill_Equity")
                DicObj.setValue(resultSet!.string(forColumn: Drill_CatID), forKey: "Drill_CatID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Difficulty_ID), forKey: "Drill_Difficulty_ID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_FocusID), forKey: "Drill_FocusID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_ShotID), forKey: "Drill_ShotID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_TrainingID), forKey: "Drill_TrainingID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_PurposeID), forKey: "Drill_PurposeID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_SituationID), forKey: "Drill_SituationID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_MetrixID), forKey: "Drill_MetrixID")
                DicObj.setValue(resultSet!.string(forColumn: CatID), forKey: "CatID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Package_ID), forKey: "Drill_Package_ID")
                DicObj.setValue(resultSet!.string(forColumn: Cat_Name), forKey: "Cat_Name")
                DicObj.setValue(resultSet!.string(forColumn: Color_ID), forKey: "Color_ID")
                DicObj.setValue(resultSet!.string(forColumn: Drill_Package_ID1), forKey: "Drill_Package_ID1")
                DicObj.setValue(resultSet!.string(forColumn: Main_Category_ID), forKey: "Main_Category_ID")
                DicObj.setValue(resultSet!.string(forColumn: Color_ID1), forKey: "Color_ID1")
                DicObj.setValue(resultSet!.string(forColumn: Package_Name), forKey: "Package_Name")
                DicObj.setValue(resultSet!.string(forColumn: Main_Category_ID1), forKey: "Main_Category_ID1")
                DicObj.setValue(resultSet!.string(forColumn: Main_Category_NAME), forKey: "Main_Category_NAME")
                DicObj.setValue(resultSet!.string(forColumn: Color_ID2), forKey: "Color_ID2")
                DicObj.setValue(resultSet!.string(forColumn: Color_ID3), forKey: "Color_ID3")
                DicObj.setValue(resultSet!.string(forColumn: Color_Name), forKey: "Color_Name")
                DicObj.setValue(resultSet!.string(forColumn: Color_Code), forKey: "Color_Code")
                DicObj.setValue(resultSet!.string(forColumn: NOOFShots), forKey: "NoOfShots")
                DicObj.setValue(resultSet!.string(forColumn: DrillTypeID), forKey: "DrillTypeID")
                print("DictionaryObject : \(DicObj))")
                ResultDrill.add(DicObj)
            }
            print("All_Drill : \(ResultDrill))")
            
        }

        
        
        
         // sharedInstance.database?.commit()

        //  sharedInstance.database!.close()
    }
    
    
    func Insert_DifficultyType(_ DifficultyType: NSMutableArray)
    {
        
        print(" \(DifficultyType)")
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

        for i in 0..<DifficultyType.count
        {
            
            let diffcultyTypeId = (DifficultyType.object(at: i) as AnyObject).value(forKey: "diffcultyTypeId")
            let diffcultyTypeName = (DifficultyType.object(at: i) as AnyObject).value(forKey: "diffcultyTypeName")
    
            let Data : NSMutableDictionary = NSMutableDictionary()
            Data.setValue(diffcultyTypeId, forKey: "diffcultyTypeId")
            Data.setValue(diffcultyTypeName, forKey: "diffcultyTypeName")

            
            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO diffculty_Master VALUES (:diffcultyTypeId, :diffcultyTypeName)", withParameterDictionary : Data as! [AnyHashable: Any]);
            print("InsertData : \(isInserted))")
       
        }
        
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
        
    }
    
    func Insert_DrillPackageColorCode(_ DrillPackageColorCode: NSMutableArray)
    {
        
        print(" \(DrillPackageColorCode)")
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()


        for i in 0 ..< DrillPackageColorCode.count
        {
            let colorID = (DrillPackageColorCode.object(at: i) as AnyObject).value(forKey: "drillPackageColorId")
            print(" \(colorID!)")

            let colorName = (DrillPackageColorCode.object(at: i) as AnyObject).value(forKey: "drillPackageColorName")
            print(" \(colorName!)")

            let colorCode = (DrillPackageColorCode.object(at: i) as AnyObject).value(forKey: "drillPackageColorCode")
            print(" \(colorCode!)")

            
            let Data : NSMutableDictionary = NSMutableDictionary()
            Data.setValue(colorID!, forKey: "colorID")
            Data.setValue(colorName!, forKey: "colorName")
            Data.setValue(colorCode!, forKey: "colorCode")
            
            
            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Drill_color_master VALUES (:colorID, :colorName, :colorCode)", withParameterDictionary : Data as! [AnyHashable: Any]);
            print("InsertData : \(isInserted)")
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()

    }
    
    
    func Insert_DrillPackage(_ DrillPackage: NSMutableArray)
    {
        
        print(" \(DrillPackage)")
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

        for i in 0 ..< DrillPackage.count
        {
            let DrillPackageID = (DrillPackage.object(at: i) as AnyObject).value(forKey: "drillPackageId")
            let MainCatId = (DrillPackage.object(at: i) as AnyObject).value(forKey: "mainCategoryId")
            let ColorID = (DrillPackage.object(at: i) as AnyObject).value(forKey: "drillPackagecolorId")
            let PackageName = (DrillPackage.object(at: i) as AnyObject).value(forKey: "packageName")

            
            let Data : NSMutableDictionary = NSMutableDictionary()
            Data.setValue(DrillPackageID, forKey: "DrillPackageID")
            Data.setValue(MainCatId, forKey: "MainCatId")
            Data.setValue(ColorID, forKey: "ColorID")
            Data.setValue(PackageName, forKey: "PackageName")

            
            
            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Drill_package VALUES (:DrillPackageID, :MainCatId, :ColorID, :PackageName)", withParameterDictionary : Data as! [AnyHashable: Any]);
            print("InsertData : \(isInserted))")
            
        }
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
        
    }
  
    
    func Insert_Drill_Main_category(_ DrillMaincategory: NSMutableArray)
    {
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        for i in 0 ..< DrillMaincategory.count 
        {
            
            let MaincatID = (DrillMaincategory.object(at: i) as AnyObject).value(forKey: "mainCategoryId")
            let MaincatName = (DrillMaincategory.object(at: i) as AnyObject).value(forKey: "mainCategoryName")
            let colorID = (DrillMaincategory.object(at: i) as AnyObject).value(forKey: "drillPackagecolorId")
            
            let Data : NSMutableDictionary = NSMutableDictionary()
            Data.setValue(MaincatID, forKey: "MaincatID")
            Data.setValue(MaincatName, forKey: "MaincatName")
            Data.setValue(colorID, forKey: "colorID")
            
            
            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Drill_main_category_master VALUES (:MaincatID, :MaincatName, :colorID)", withParameterDictionary : Data as! [AnyHashable: Any]);
            print("InsertData : \(isInserted))")
            
        }
        
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
        
    }
    
    
    func Insert_Drill_Type(_ DrillType: NSMutableArray)
    {
        
        print(" \(DrillType)")
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

        for i in 0 ..< DrillType.count
        {
            let DrillTypeID = (DrillType.object(at: i) as AnyObject).value(forKey: "drillTypeId")
            let DrillTypeName = (DrillType.object(at: i) as AnyObject).value(forKey: "drillType")
            
            let Data : NSMutableDictionary = NSMutableDictionary()
            Data.setValue(DrillTypeID, forKey: "DrillTypeID")
            Data.setValue(DrillTypeName, forKey: "DrillTypeName")
            
            
            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Drill_type VALUES (:DrillTypeID, :DrillTypeName)", withParameterDictionary : Data as! [AnyHashable: Any]);
            print("InsertData : \(isInserted)")
            
        }
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
    }
    
    
    func Insert_FocusType(_ FocusType: NSMutableArray)
    {
        
        print(" \(FocusType)")
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

        for i in 0 ..< FocusType.count 
        {
            
            let focusTypeId = (FocusType.object(at: i) as AnyObject).value(forKey: "focusTypeId")
            let focusTypeName = (FocusType.object(at: i) as AnyObject).value(forKey: "focusTypeName")
            
            let Data : NSMutableDictionary = NSMutableDictionary()
            Data.setValue(focusTypeId, forKey: "focusTypeId")
            Data.setValue(focusTypeName, forKey: "focusTypeName")
            
            
            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO focus_Master VALUES (:focusTypeId, :focusTypeName)", withParameterDictionary : Data as! [AnyHashable: Any]);
            print("InsertData : \(isInserted))")
            
        }
        
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
    }
    
    func Insert_PurposeType(_ PurposeType: NSMutableArray)
    {
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        for i in 0 ..< PurposeType.count 
        {
            let purposeTypeId = (PurposeType.object(at: i) as AnyObject).value(forKey: "purposeTypeId")
            let purposeTypeName = (PurposeType.object(at: i) as AnyObject).value(forKey: "purposeTypeName")
            
            let Data : NSMutableDictionary = NSMutableDictionary()
            Data.setValue(purposeTypeId, forKey: "purposeTypeId")
            Data.setValue(purposeTypeName, forKey: "purposeTypeName")
            
            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Purpose_type_master VALUES (:purposeTypeId, :purposeTypeName)", withParameterDictionary : Data as! [AnyHashable: Any]);
            print("InsertData : \(isInserted))")
            
        }
        
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
        
    }
    
    func Insert_TrainigType(_ TrainingType: NSMutableArray)
    {
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

        for i in 0 ..< TrainingType.count
        {
            let traningTypeId = (TrainingType.object(at: i) as AnyObject).value(forKey: "traningTypeId")
            let traningTypeName = (TrainingType.object(at: i) as AnyObject).value(forKey: "traningTypeName")
            
            let Data : NSMutableDictionary = NSMutableDictionary()
            Data.setValue(traningTypeId, forKey: "traningTypeId")
            Data.setValue(traningTypeName, forKey: "traningTypeName")
            
            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO training_Master VALUES (:traningTypeId, :traningTypeName)", withParameterDictionary : Data as! [AnyHashable: Any]);
            print("InsertData : \(isInserted))")
            
        }
        
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()

    }
    
    func Insert_Shot_Type(_ ShotType: NSMutableArray)
    {
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

        for i in 0 ..< ShotType.count
        {
            
            let ShotTypeID = (ShotType.object(at: i) as AnyObject).value(forKey: "shotTypeId")
            let ShotTypeName = (ShotType.object(at: i) as AnyObject).value(forKey: "shotTypeName")
            
            let Data : NSMutableDictionary = NSMutableDictionary()
            Data.setValue(ShotTypeID, forKey: "ShotTypeID")
            Data.setValue(ShotTypeName, forKey: "ShotTypeName")
            
            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Shot_type_Master VALUES (:ShotTypeID, :ShotTypeName)", withParameterDictionary : Data as! [AnyHashable: Any]);
            print("InsertData : \(isInserted))")
            
        }
        
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
        
    }
    
    
    
    func Insert_Plan_Type(_ PlanType: NSMutableArray)
    {
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        for i in 0 ..< PlanType.count 
        {
            
            let PlanTypeID = (PlanType.object(at: i) as AnyObject).value(forKey: "planTypeId")
            let PlanTypeName = (PlanType.object(at: i) as AnyObject).value(forKey: "planType")
            
            let Data : NSMutableDictionary = NSMutableDictionary()
            Data.setValue(PlanTypeID, forKey: "PlanTypeId")
            Data.setValue(PlanTypeName, forKey: "PlanType")
            
            
            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO planType VALUES (:PlanTypeId, :PlanType)", withParameterDictionary : Data as! [AnyHashable: Any]);
            print("InsertData : \(isInserted))")
            
        }
        
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()

    }
    
    
    
    func Database_PlanType(_ PurposeType: NSMutableArray){
        
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

        let querySQL = "select * from planType"
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        let PlanTypeId: String = "PlanTypeId"
        let PlanType: String = "PlanType"
        if (resultSet != nil) {
            while resultSet?.next() == true {
                print("CategoryId : \(resultSet!.string(forColumn: PlanTypeId))")
                print("CategoryName : \(resultSet!.string(forColumn: PlanType))")
                
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj .setValue(resultSet!.string(forColumn: PlanTypeId), forKey: "PlanTypeId")
                DicObj .setValue(resultSet!.string(forColumn: PlanType), forKey: "PlanType")
                PurposeType.add(DicObj)
            }
            
        }
         // sharedInstance.database?.commit()

        //  sharedInstance.database!.close()
        
    }
    
    
    
    
    
    
    
    func Insert_DrillCategoryMasterType(_ DrillCategoryMaster: NSMutableArray)
    {
        
        
        
        
        
//        let querySQL = "DELETE FROM Drill_category_master";
//        print("query : \(querySQL)")
//        
//        let flag: Bool
//        
//        flag =  database!.executeStatements(querySQL)
//        
//        
//        print(flag)

        
        
    //  print()

        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

        for i in 0 ..< DrillCategoryMaster.count 
        {
            
            let CategoryID = (DrillCategoryMaster.object(at: i) as AnyObject).value(forKey: "drillCategoryId")
            let DrillPackageID = (DrillCategoryMaster.object(at: i) as AnyObject).value(forKey: "drillPackageId")
            let CategoryName = (DrillCategoryMaster.object(at: i) as AnyObject).value(forKey: "categoryName")
            let ColorID = (DrillCategoryMaster.object(at: i) as AnyObject).value(forKey: "drillPackageColorId")
            let short_label = (DrillCategoryMaster.object(at: i) as AnyObject).value(forKey: "shortlabel")
            
            let Data : NSMutableDictionary = NSMutableDictionary()
            Data.setValue(CategoryID, forKey: "CategoryID")
            Data.setValue(DrillPackageID, forKey: "DrillPackageID")
            Data.setValue(CategoryName, forKey: "CategoryName")
            Data.setValue(ColorID, forKey: "ColorID")
            Data.setValue(short_label, forKey: "short_label")
            
            
            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Drill_category_master VALUES (:CategoryID, :DrillPackageID, :CategoryName, :ColorID,:short_label)", withParameterDictionary : Data as! [AnyHashable: Any]);
            print("InsertData : \(isInserted))")
            print(i)
            
        }
        
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()

    }
    
    func Insert_Matrix_master(_ Matrixmaster: NSMutableArray)
    {
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        for i in 0 ..< Matrixmaster.count 
        {
            
            let MetrixID = (Matrixmaster.object(at: i) as AnyObject).value(forKey: "metrixId")
            let MetrixType = (Matrixmaster.object(at: i) as AnyObject).value(forKey: "metrixType")
            let MetrixRow = (Matrixmaster.object(at: i) as AnyObject).value(forKey: "metrixRow")
            let MetrixCol = (Matrixmaster.object(at: i) as AnyObject).value(forKey: "metrixCol")
            
            let Data : NSMutableDictionary = NSMutableDictionary()
            Data.setValue(MetrixID, forKey: "MetrixID")
            Data.setValue(MetrixType, forKey: "MetrixType")
            Data.setValue(MetrixRow, forKey: "MetrixRow")
            Data.setValue(MetrixCol, forKey: "MetrixCol")
            
            
            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Matrix_master VALUES (:MetrixID, :MetrixType, :MetrixRow, :MetrixCol)", withParameterDictionary : Data as! [AnyHashable: Any]);
            print("InsertData : \(isInserted))")
            
        }
        
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()

    }

    func Database_MetrixDetails(_ MetrixArray: NSMutableArray, ResultmetrixValueID : NSString)
    {
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        print(ResultmetrixValueID)

        
        let querySQL = NSString(format:"select * from drill_Result_matrixValue where drillresultmetrixid = %@", ResultmetrixValueID) as String
        
        print(querySQL)
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        let resultmatrixvalueId: String = "resultmatrixvalueId"
        let drillresultmetrixId: String = "drillresultmetrixId"
        let drillresultmetrixRow: String = "drillresultmetrixRow"
        let drillresultmetrixCol: String = "drillresultmetrixCol"
        let drillresultmetrixValue: String = "drillresultmetrixValue"
        
        
        if (resultSet != nil) {
            while resultSet?.next() == true
            {
                
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj .setValue(resultSet!.string(forColumn: resultmatrixvalueId), forKey: "resultmatrixvalueId")
                DicObj .setValue(resultSet!.string(forColumn: drillresultmetrixId), forKey: "drillresultmetrixId")
                DicObj .setValue(resultSet!.string(forColumn: drillresultmetrixRow), forKey: "drillresultmetrixRow")
                DicObj .setValue(resultSet!.string(forColumn: drillresultmetrixCol), forKey: "drillresultmetrixCol")
                DicObj .setValue(resultSet!.string(forColumn: drillresultmetrixValue), forKey: "drillresultmetrixValue")
               MetrixArray.add(DicObj)
            }
            
        }
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
    }

    
    
    func Insert_SituationType(_ SituationType: NSMutableArray)
    {
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()

        for i in 0 ..< SituationType.count 
        {
            
            let situationId = (SituationType.object(at: i) as AnyObject).value(forKey: "situationId")
            let situationName = (SituationType.object(at: i) as AnyObject).value(forKey: "situationName")
            let situationValue = (SituationType.object(at: i) as AnyObject).value(forKey: "situationValue")

            let Data : NSMutableDictionary = NSMutableDictionary()
            Data.setValue(situationId, forKey: "situationId")
            Data.setValue(situationName, forKey: "situationName")
            Data.setValue(situationValue, forKey: "situationValue")

            
            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO No_of_situation VALUES (:situationId, :situationName, :situationValue)", withParameterDictionary : Data as! [AnyHashable: Any]);
            print("InsertData : \(isInserted))")
            
        }
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()

    }
    
    
    func Insert_PlanBreak(_ PlanBreak: NSMutableArray)
    {
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        for i in 0 ..< PlanBreak.count
        {
            
            let PlanBreakID = (PlanBreak.object(at: i) as AnyObject).value(forKey: "planBreakId")
            let PlanBreakTimeMili = (PlanBreak.object(at: i) as AnyObject).value(forKey: "planBreakTimeMili")
            
            let Data : NSMutableDictionary = NSMutableDictionary()
            Data.setValue(PlanBreakID, forKey: "PlanBreakID")
            Data.setValue(PlanBreakTimeMili, forKey: "PlanBreakTimeMili")
            
            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO PlanBreak VALUES (:PlanBreakID, :PlanBreakTimeMili)", withParameterDictionary : Data as! [AnyHashable: Any]);
            print("InsertData : \(isInserted))")
            
        }
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
    }
    
    func getstudentresult(_ userid:String)->NSMutableArray
    {
        
        let studentdata = NSMutableArray()
     
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        
        let querySQL="select drill_id,title,drillResultTime,estimat_time,no_of_shots  from Result_Metrix RM inner join drill_Info DI on RM.drillId = DI.drill_id where RM.userId = \(userid)"
        
        
        print(querySQL)
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        if (resultSet != nil) {
            while resultSet?.next() == true
            {
                
                
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                print(resultSet!.string(forColumn: "drill_id"))
                DicObj.setValue(resultSet!.string(forColumn: "drill_id"), forKey: "drill_id")
                DicObj.setValue(resultSet!.string(forColumn: "estimat_time"), forKey: "estimat_time")
                DicObj.setValue(resultSet!.string(forColumn: "no_of_shots"), forKey: "no_of_shots")
                DicObj.setValue(resultSet!.string(forColumn: "drillResultTime"), forKey: "drillResultTime")
                
                DicObj.setValue(resultSet!.string(forColumn: "title"), forKey: "title")
                
                studentdata.add(DicObj)
            }
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        return studentdata
    }
    
    func get_own_result(_ userid:String)->NSMutableArray
    {
        let studentdata = NSMutableArray()
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        let querySQL="select estimat_time,no_of_shots  from Result_Metrix RM inner join drill_Info DI on RM.drillId = DI.drill_id where RM.userId = \(userid)"
        
        print(querySQL)
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        if (resultSet != nil) {
            while resultSet?.next() == true
            {
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj.setValue(resultSet!.string(forColumn: "estimat_time"), forKey: "estimat_time")
                DicObj.setValue(resultSet!.string(forColumn: "no_of_shots"), forKey: "no_of_shots")
                studentdata.add(DicObj)
            }
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        return studentdata
    }
    
    
    func get_drill_result_shot_count(_ plainid : String,filter:String,userid:String,plantranarray:NSMutableArray) -> Int
    {
        var count = 0
        sharedInstance.database!.open()
        
        // sharedInstance.database?.beginTransaction()
        
        
        var querySQL = ""
        
        
        if filter == "3" || filter == "7" || filter == "8"
        {
            
            querySQL =  "select drillPlanTransactionId  from Result_Metrix RM inner join drill_Info DI on RM.drillId = DI.drill_id inner join Drill_category_master DCM on DCM.category_id = DI.category_id   where  RM.planId  = \(plainid) AND DCM.color_id = 3 or DCM.color_id = 7 or DCM.color_id = 8 AND RM.userId = \(userid)"
            
        }
        else
        {
            querySQL   = "select drillPlanTransactionId  from Result_Metrix RM inner join drill_Info DI on RM.drillId = DI.drill_id inner join Drill_category_master DCM on DCM.category_id = DI.category_id   where  RM.planId  = \(plainid) AND DCM.color_id = \(filter) AND RM.userId = \(userid)"
        }
        
        
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        if (resultSet != nil)
        {
            while resultSet?.next() == true
            {
                
                
                let plantranid = resultSet!.string(forColumn: "drillPlanTransactionId")!
                
                
                
                for i in 0  ..< plantranarray.count 
                {
                    let str = plantranarray[i] as! String
                    
                    
                    if str == plantranid
                    {
                        count = count + 1
                        
                        break
                    }
                }
                
            }
            
            
            
        }
        
        
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        return count
        
    }
    
    
    
    
   
    
    
    
    func get_drill_result_type_count(_ plainid : String,filter:String,userid:String,plantranarray:NSMutableArray) -> Int
    {
        
        
        var count = 0
        sharedInstance.database!.open()
        
        // sharedInstance.database?.beginTransaction()
        var querySQL = ""
        
        
        
        
       
       
           querySQL =  "select drillPlanTransactionId  from Result_Metrix RM inner join drill_Info DI on RM.drillId = DI.drill_id inner join Drill_category_master DCM on DCM.category_id = DI.category_id inner join Drill_package DP on  DCM.drill_package_id = DP.drill_package_id  where  RM.planId  = \(plainid) AND DP.main_category_id = \(filter) AND RM.userId = \(userid)"
        
        
        
        
        
         let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        if (resultSet != nil)
        {
            while resultSet?.next() == true
            {
                
                
                let plantranid = resultSet!.string(forColumn: "drillPlanTransactionId")!
                
                
                
                for i in 0  ..< plantranarray.count 
                {
                    let str = plantranarray[i] as! String
                    
                    if str == plantranid
                    {
                        count = count + 1
                        
                        break
                    }
                }
            }
                
        }
            
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        return count
    }
    
    
    func fetchcolor_by_category(_ catid:String) -> String
    {
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        
        let querySQL = "select color_id from Drill_category_master where category_id = \(catid)"
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        var colorid = ""
        
        if (resultSet != nil)
        {
            while resultSet?.next() == true {
              colorid = resultSet!.string(forColumn: "color_id")!
            }
            
        }
        
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
        
        return colorid
    }
    
    
    func Database_fetchColor(_ catID : String,colorData: NSMutableArray){
        sharedInstance.database!.open()
        
        if sharedInstance.database!.open() == false
        {
            sharedInstance.database!.open()
        }
        
        // sharedInstance.database?.beginTransaction()

        
//        sharedInstanceQueue.databaseQueue!.inDeferredTransaction { database, rollback in
//            do
//            {
//                
//
//            }
//            catch
//            {
//                rollback!.pointee = true
//                print(error)
//            }
//        }
        
//        let querySQL = "select * from Drill_category_master DCM, Drill_color_master DM Where DCM.color_id = DM.color_id and  category_id = \(catID)"
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("select * from Drill_category_master DCM, Drill_color_master DM Where DCM.color_id = DM.color_id and  category_id = ?", withArgumentsIn: [catID])
        
        let category_id: String = "category_id"
        let drill_package_id: String = "drill_package_id"
        let category_name: String = "category_name"
        let color_id: String = "color_id"
        let color_id1: String = "color_id"
        let color_name: String = "color_name"
        let color_code: String = "color_code"
        
        if (resultSet != nil) {
            while resultSet?.next() == true {
                
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj .setValue(resultSet!.string(forColumn: category_id), forKey: "category_id")
                DicObj .setValue(resultSet!.string(forColumn: drill_package_id), forKey: "drill_package_id")
                DicObj .setValue(resultSet!.string(forColumn: category_name), forKey: "category_name")
                DicObj .setValue(resultSet!.string(forColumn: color_id), forKey: "color_id")
                DicObj .setValue(resultSet!.string(forColumn: color_id1), forKey: "color_id1")
                DicObj .setValue(resultSet!.string(forColumn: color_name), forKey: "color_name")
                DicObj .setValue(resultSet!.string(forColumn: color_code), forKey: "color_code")
                colorData.add(DicObj)
            }
        }

        
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
     }
    
    
    
    func Insert_StudentList(_ studentList: NSMutableArray, teacherId : String)
    {
        print(" \(studentList)")
        
        
        
           for i in 0 ..< studentList.count 
           {
            sharedInstance.database!.open()
            // sharedInstance.database?.beginTransaction()
            
            let student_user_id = (studentList.object(at: i) as AnyObject).value(forKey: "userId")
            let userRelationshipId = (studentList.object(at: i) as AnyObject).value(forKey: "userRelationshipId")
            let trainer_user_id = teacherId
            
            let Data : NSMutableDictionary = NSMutableDictionary()
            Data.setValue(userRelationshipId, forKey: "userRelationshipId")
            Data.setValue(student_user_id, forKey: "student_user_id")
            Data.setValue(trainer_user_id, forKey: "trainer_user_id")
            
            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO User_relationship(relationship_id, student_user_id, trainer_user_id) VALUES (:userRelationshipId, :student_user_id, :trainer_user_id)", withParameterDictionary : Data as! [AnyHashable: Any]);
            print("InsertData : \(isInserted))")
             // sharedInstance.database?.commit()
            
            //  sharedInstance.database!.close()
        }
        
        self.Insert_UserDetail2(studentList)
        
    }
    
    
    func Database_ResultOfStudent(_ ResultDrill : NSMutableArray)
    {
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        let querySQL = NSString(format:"select * from Result_Metrix RM,Drill_Info DI,User us Where DI.drill_id=RM.drillId  AND  us.userId=DI.CreatedbyuserId AND us.userId=RM.userId") as String
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        let DrillResultMetrixId: String = "drillresultMetrixId"
        let UserID: String = "userId"
        let DrillID: String = "drillId"
        let PlanID: String = "planId"
        let Comment: String = "comment"
        let Totalresult: String = "totalResult"
        let DrillresultTime: String = "drillResultTime"
        let Drill_ID: String = "drill_id"
        let Drill_Title: String = "title"
        let Drill_Short_DESC: String = "abstract_description"
        let Drill_Long_DESC: String = "long_description"
        let Drill_Est_time: String = "estimat_time"
        let Drill_Equity: String = "hundred_percent_equi_value"
        let Drill_CatID: String = "category_id"
        let Drill_Difficulty_ID: String = "diffculty_type_id"
        let Drill_FocusID: String = "focus_type_id"
        let Drill_ShotID: String = "shot_type_id"
        let Drill_TrainingID: String = "traning_type_id"
        let Drill_PurposeID: String = "purpose_type_id"
        let Drill_SituationID: String = "situation_type_id"
        let Drill_MetrixID: String = "metrix_id"
        let no_of_shots: String = "no_of_shots"
        let drillTypeid: String = "drillTypeid"
        let CreatedByuserId: String = "CreatedByuserId"
        
        
        
        //  let userId: String = "userId"
        let userName: String = "userName"
        //let CreatedByuserId: String = "CreatedByuserId"
        
        
        
        
        if (resultSet != nil) {
            while resultSet?.next() == true
            {
                
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj .setValue(resultSet!.string(forColumn: DrillResultMetrixId), forKey: "DrillResultMetrixId")
                DicObj .setValue(resultSet!.string(forColumn: UserID), forKey: "UserID")
                DicObj .setValue(resultSet!.string(forColumn: DrillID), forKey: "DrillID")
                DicObj .setValue(resultSet!.string(forColumn: PlanID), forKey: "PlanID")
                DicObj .setValue(resultSet!.string(forColumn: Comment), forKey: "Comment")
                DicObj .setValue(resultSet!.string(forColumn: Totalresult), forKey: "Totalresult")
                DicObj .setValue(resultSet!.string(forColumn: DrillresultTime), forKey: "DrillresultTime")
                
                DicObj .setValue(resultSet!.string(forColumn: Drill_ID), forKey: "Drill_ID")
                DicObj .setValue(resultSet!.string(forColumn: Drill_Title), forKey: "Drill_Title")
                DicObj .setValue(resultSet!.string(forColumn: Drill_Short_DESC), forKey: "Drill_Short_DESC")
                DicObj .setValue(resultSet!.string(forColumn: Drill_Long_DESC), forKey: "Drill_Long_DESC")
                DicObj .setValue(resultSet!.string(forColumn: Drill_Est_time), forKey: "Drill_Est_time")
                DicObj .setValue(resultSet!.string(forColumn: Drill_Equity), forKey: "Drill_Equity")
                DicObj .setValue(resultSet!.string(forColumn: Drill_CatID), forKey: "Drill_CatID")
                DicObj .setValue(resultSet!.string(forColumn: Drill_Difficulty_ID), forKey: "Drill_Difficulty_ID")
                DicObj .setValue(resultSet!.string(forColumn: Drill_FocusID), forKey: "Drill_FocusID")
                DicObj .setValue(resultSet!.string(forColumn: Drill_ShotID), forKey: "Drill_ShotID")
                DicObj .setValue(resultSet!.string(forColumn: Drill_TrainingID), forKey: "Drill_TrainingID")
                DicObj .setValue(resultSet!.string(forColumn: Drill_PurposeID), forKey: "Drill_PurposeID")
                DicObj .setValue(resultSet!.string(forColumn: Drill_SituationID), forKey: "Drill_SituationID")
                DicObj .setValue(resultSet!.string(forColumn: Drill_MetrixID), forKey: "Drill_MetrixID")
                DicObj .setValue(resultSet!.string(forColumn: no_of_shots), forKey: "no_of_shots")
                DicObj .setValue(resultSet!.string(forColumn: drillTypeid), forKey: "drillTypeid")
                DicObj .setValue(resultSet!.string(forColumn: CreatedByuserId), forKey: "CreatedByuserId")
                
                DicObj.setValue(resultSet!.string(forColumn: userName), forKey: "userName")
                
                
                ResultDrill.add(DicObj)
            }
            
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
    }
    
    func Insert_TeacherAssignedPlan(_ TeacherAssignedPlan: NSMutableArray, teacherId : String)
    {
        
        print(TeacherAssignedPlan)
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        for i in 0 ..< TeacherAssignedPlan.count 
        {
            
            let teacherAssignedPlanId = (TeacherAssignedPlan.object(at: i) as AnyObject).value(forKey: "teacherAssignedPlanId")
            let studentUserId = (TeacherAssignedPlan.object(at: i) as AnyObject).value(forKey: "studentUserId")
            let planId = (TeacherAssignedPlan.object(at: i) as AnyObject).value(forKey: "planId")
            let teacherUserId = (TeacherAssignedPlan.object(at: i) as AnyObject).value(forKey: "teacherUserId")
            
            let Data : NSMutableDictionary = NSMutableDictionary()
            Data.setValue(teacherAssignedPlanId, forKey: "teacherAssignedPlanId")
            Data.setValue(studentUserId, forKey: "studentUserId")
            Data.setValue(planId, forKey: "planId")
            Data.setValue(teacherUserId, forKey: "teacherUserId")
            
            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO TeacherAssignedPlan(teacherAssignedPlanId, studentUserId, planId,teacherUserId) VALUES (:teacherAssignedPlanId, :studentUserId, :planId, :teacherUserId)", withParameterDictionary : Data as! [AnyHashable: Any]);
            print("InsertData : \(isInserted))")
            
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        
    }

    func Database_TeacherAssignPlan(_ PlanArray: NSMutableArray)
    {
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        let querySQL = NSString(format:"select * from TeacherAssignedPlan") as String
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        let teacherAssignedPlanId: String = "teacherAssignedPlanId"
        let studentUserId: String = "studentUserId"
        let planId: String = "planId"
        let teacherUserId: String = "teacherUserId"
        
        if (resultSet != nil) {
            while resultSet?.next() == true
            {
                let DicObj:NSMutableDictionary = NSMutableDictionary()
                DicObj .setValue(resultSet!.string(forColumn: teacherAssignedPlanId), forKey: "teacherAssignedPlanId")
                DicObj .setValue(resultSet!.string(forColumn: studentUserId), forKey: "studentUserId")
                DicObj .setValue(resultSet!.string(forColumn: planId), forKey: "planId")
                DicObj .setValue(resultSet!.string(forColumn: teacherUserId), forKey: "teacherUserId")
                PlanArray.add(DicObj)
            }
            
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
    }


    func Insert_TeacherInfo(_ TeacherAssignedPlan: NSMutableArray)
    {
        
        print(TeacherAssignedPlan)
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        for i in 0 ..< TeacherAssignedPlan.count 
        {
            
            let teacherId = (TeacherAssignedPlan.object(at: i) as AnyObject).value(forKey: "teacherAssignedPlanId")
            let userId = (TeacherAssignedPlan.object(at: i) as AnyObject).value(forKey: "studentUserId")
            let paidAmount = (TeacherAssignedPlan.object(at: i) as AnyObject).value(forKey: "planId")
            let skills = (TeacherAssignedPlan.object(at: i) as AnyObject).value(forKey: "teacherUserId")
            let isActiveSubscription = (TeacherAssignedPlan.object(at: i) as AnyObject).value(forKey: "teacherAssignedPlanId")
            let subscriptionDate = (TeacherAssignedPlan.object(at: i) as AnyObject).value(forKey: "studentUserId")
            let profileStatus = (TeacherAssignedPlan.object(at: i) as AnyObject).value(forKey: "planId")
            let privateCode = (TeacherAssignedPlan.object(at: i) as AnyObject).value(forKey: "teacherUserId")
            
            
            let Data : NSMutableDictionary = NSMutableDictionary()
            Data.setValue(teacherId, forKey: "teacherId")
            Data.setValue(userId, forKey: "userId")
            Data.setValue(paidAmount, forKey: "paidAmount")
            Data.setValue(skills, forKey: "skills")
            Data.setValue(isActiveSubscription, forKey: "isActiveSubscription")
            Data.setValue(subscriptionDate, forKey: "subscriptionDate")
            Data.setValue(profileStatus, forKey: "profileStatus")
            Data.setValue(privateCode, forKey: "privateCode")
            
            
            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO teacherInfo(teacherId, userId, paidAmount, skills, isActiveSubscription, subscriptionDate, profileStatus, privateCode) VALUES (:teacherId, :userId, :paidAmount, :skills,:isActiveSubscription, :subscriptionDate, :profileStatus, :privateCode)", withParameterDictionary : Data as! [AnyHashable: Any]);
            print("InsertData : \(isInserted))")
            
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        
    }

    
    
    
    
    func Delete_transaction(_ TransId: String)
    {
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        let querySQL = "DELETE FROM Drill_plan_transaction Where plan_id = \(TransId)";
        print("query : \(querySQL)")
        
        let flag: Bool
        
        flag =  database!.executeStatements(querySQL)
        
        print("flag : \(flag)")
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        
    }
    
    func DeletePlan(_ userId: String)
    {
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        let querySQL = "DELETE FROM plan WHERE planTypeId = 3";
         print("query : \(querySQL)")
        
        let flag: Bool
        
        flag =  database!.executeStatements(querySQL)
        
        print("flag : \(flag)")
        
        //"UPDATE " + TAB_USER_MASTER + " SET " + TEACHER_ASSIGNED_ACTIVE_PLAN_ID + " = "
            //+ planId + " WHERE " + USER_ID + " = " + currentUserId
        let querySQL1 = sharedInstance.database!.executeUpdate("UPDATE User SET teacherAssignActivePlan = 0 WHERE userId = \(userId)", withParameterDictionary : nil);

        
       // let querySQL1 = "UPDATE FROM Result_Metrix Where plan_id = \(plan)";
        print("query : \(querySQL1)")
        
        let flag1: Bool
        
        flag1 =  database!.executeStatements(querySQL)
        
        print("flag : \(flag1)")
        
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
    }
    
    func Delete_Drill_transaction(_ TransId: String)
    {
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        let querySQL = "DELETE FROM Drill_plan_transaction Where plan_transaction_id = \(TransId)";
        print("query : \(querySQL)")
        
        let flag: Bool
        
        flag =  database!.executeStatements(querySQL)
        
        print("flag : \(flag)")
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        
    }
    

    func Insert_single_student(_ studentid:Int, teacherId : Int,relationship_id : Int)
    {
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        let Data : NSMutableDictionary = NSMutableDictionary()
        Data.setValue(studentid, forKey: "student_user_id")
        Data.setValue(teacherId, forKey: "trainer_user_id")
        Data.setValue(relationship_id, forKey: "relationship_id")
        //Data.setValue(userRelationshipId, forKey: "userRelationshipId")
        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO User_relationship(relationship_id,student_user_id,trainer_user_id) VALUES (:relationship_id,:student_user_id,:trainer_user_id)", withParameterDictionary : Data as! [AnyHashable: Any]);
        
        print(isInserted)
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
        
    }
    
    
    func get_pre_plan_sub_cat(_ pid:NSString)-> NSMutableArray
    {
        
        sharedInstance.database!.open()
        
        // sharedInstance.database?.beginTransaction()
        
        let studentlist = NSMutableArray()
        
        let querySQL = "select * from pre_plan_sub_cat where palnMainCategoryId = \(pid)"
        //userName
        //        let DrillResultMetrixId: String = "relationship_id"
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        if (resultSet != nil) {
            while resultSet?.next() == true
            {
                
                let dic1=["planSubCategoryId":resultSet!.string(forColumn: "planSubCategoryId"),"CategoryName":resultSet!.string(forColumn: "CategoryName"),"palnMainCategoryId":resultSet!.string(forColumn: "palnMainCategoryId")]
                
                studentlist.add(dic1)
                
                
            }
        }
        
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        
        return studentlist;
        
        
    }
    
    
    
    
    
    
    
    
    func get_country123(_ tablename:String,id : String) -> NSMutableArray
    {
        
        sharedInstance.database!.open()
        
        // sharedInstance.database?.beginTransaction()
        
        var country_list = NSMutableArray()
       
    //    let querySQL = "select * from \(tablename) where id = \(id)"
        var query = ""
        
        if tablename == "CountryList"
        {
            query = "select * from countries"
            
            
        }
        else if (tablename == "StateList")
        {
            query = "select * from states  where country_id = \(id)"
        }
        else
        {
            query = "select * from cities  where state_id = \(id)"
        }
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(query, withArgumentsIn: nil)
        
        if (resultSet != nil)
        {
            while resultSet?.next() == true
            {
                let dic1=["id":resultSet!.string(forColumn: "id"),"name":resultSet!.string(forColumn: "name")]as! NSDictionary
                    
                    country_list.add(dic1)
                    
        
            }
        }
        
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        
        return country_list
    }
    
    func getstudentlist() -> NSMutableArray
    {
        let defaults = UserDefaults.standard
        let tid = defaults.string(forKey: "UserId")
        
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        var studentlist = NSMutableArray()
        
        
        let querySQL = NSString(format:"select * from User_relationship inner join User on User_relationship.student_user_id = User.userId where User_relationship.trainer_user_id = '%@'",tid!) as String
        //userName
        //        let DrillResultMetrixId: String = "relationship_id"
        let student_user_id: String = "student_user_id"
        let trainer_user_id: String = "trainer_user_id"
        let username: String = "userName"
        let userImage: String = "userimage"
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery(querySQL, withArgumentsIn: nil)
        
        if (resultSet != nil) {
            while resultSet?.next() == true
            {
                
                let dic1=["studentid":resultSet!.string(forColumn: student_user_id),"teacherid":resultSet!.string(forColumn: trainer_user_id),"sname":resultSet!.string(forColumn: username),"userImage":resultSet!.string(forColumn: userImage)] as! NSMutableDictionary
                
                studentlist.add(dic1)
                
                
            }
        }
         // sharedInstance.database?.commit()
        
        //  sharedInstance.database!.close()
        
        return studentlist;
        
    }
    
    func Delete_All_Data()
    {
        sharedInstance.database!.open()
        // sharedInstance.database?.beginTransaction()
        
        let querySQL = "delete FROM Drill_Info"
        let  xx : Bool
        xx =  sharedInstance.database!.executeUpdate(querySQL, withArgumentsIn: nil)
        print("query : \(xx)")
        
        let querySQL1 = "delete FROM Plan"
        let  xx1 : Bool
        xx1 =  sharedInstance.database!.executeUpdate(querySQL1, withArgumentsIn: nil)
        print("query : \(xx1)")
        
        
        
        let querySQL2 = "DELETE FROM Illustration_media "
        let  xx2 : Bool
        xx2 =  sharedInstance.database!.executeUpdate(querySQL2, withArgumentsIn: nil)
        print("query : \(xx2)")
        
        
        let querySQL3 = "DELETE FROM User"
        
        let  xx3 : Bool
        xx3 =  sharedInstance.database!.executeUpdate(querySQL3, withArgumentsIn: nil)
        
        print("query : \(xx3)")
        
        
        let querySQL4 = "delete FROM Result_Metrix"
        
        let  xx4 : Bool
        xx4 =  sharedInstance.database!.executeUpdate(querySQL4, withArgumentsIn: nil)
        
        print("query : \(xx4)")
        
         // sharedInstance.database?.commit()
        //  sharedInstance.database!.close()
      
    }
    
    
    func deletedatabase()
    {
        
      //  UserDefaults.standard.set("0", forKey: "isLoginConfirm")

        UserDefaults.standard.removeObject(forKey: "isLoginConfirm")
        let path = Util.getPath("golf.sqlite")
        
        
        if FileManager.default.fileExists(atPath: path)
        {
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch
            {
                print("an error during a removing")
            }
        }
    }
    */
    */
}
