global class TestPageController{

    global Account[] accountList{
        get{
            return [SELECT Id, Name FROM Account];
        }
        
    }



}