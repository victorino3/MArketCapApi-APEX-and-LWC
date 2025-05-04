public with sharing class LeadTriggerHandler {
    public static Boolean stopRecursive = false;
   public static void beforeInsertAction(List<Lead>leadList,Boolean isBefore,Boolean isUpdate){
    for (Lead myLead : leadList) {
        if (isBefore) {
            myLead.LeadSource = 'VsCode';
        }
        if (String.isBlank(myLead.Industry) ||  isUpdate) {
            myLead.addError('The Industry Field cannot be blank');
        }
    }
   }
   public static void afterInsertAction(List<Lead>leadList){
    List<Task> leadTask = new List<Task>();
            for (Lead myLead : leadList) {
                
                if (Schema.sObjectType.Task.isCreateable()) {
                    Task task = new Task(Subject='Lead task', whoId=myLead.Id);
                    leadTask.add(task);
                } else {
                   
                    System.debug('Usuário não tem permissão para criar tarefas.');
                }
            }
            
            if (!leadTask.isEmpty() && Schema.sObjectType.Task.isCreateable()) {
                insert leadTask;
            }
            if (LeadTriggerHandler.stopRecursive == false) {
                LeadTriggerHandler.stopRecursive = true;
                Lead lead = new Lead(LastName='Steward',Industry='Musical',Company='LWC');
                if (lead != null  && Schema.sObjectType.Lead.isCreateable()) {                     
                        insert lead;
                    }
                    
            }
            
            
   }
   public static void beforeUpdateAction(List<Lead>lead,Map<Id,Lead>oldMap,Boolean isBefore){
    for (Lead myLead : lead) {
        if (isBefore) {
            myLead.LeadSource = 'VsCode';
        }
        if ((myLead.Status == 'Closed - Converted' || myLead.Status == 'Closed - Not Converted') && 
            oldMap.get(myLead.Id).Status == 'Open - Not Contacted' ) {
                myLead.Status.addError('You cannot close this Lead in the current status');
            }

    }
    
   }
}