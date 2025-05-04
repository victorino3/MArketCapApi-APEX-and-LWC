// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class Knowledge__ka {
    global Id Id;
    global Boolean IsDeleted;
    global Datetime CreatedDate;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime LastModifiedDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime SystemModstamp;
    global String ArticleNumber;
    global Datetime ArchivedDate;
    global User ArchivedBy;
    global Id ArchivedById;
    global Datetime FirstPublishedDate;
    global Datetime LastPublishedDate;
    global Integer CaseAssociationCount;
    global Datetime LastViewedDate;
    global Datetime LastReferencedDate;
    global String MigratedToFromArticle;
    global Integer TotalViewCount;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<CaseArticle> CaseArticles;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<FlowOrchestrationWorkItem> FlowOrchestrationWorkItems;
    global List<Knowledge__ViewStat> ViewStats;
    global List<Knowledge__VoteStat> VoteStats;
    global List<LinkedArticle> LinkedArticles;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<Vote> Votes;
    global List<ContentDocumentLinkChangeEvent> LinkedEntity;
    global List<ContentVersion> FirstPublishLocation;
    global List<FeedAttachment> Record;
    global List<FeedComment> Parent;
    global List<Knowledge__kav> KnowledgeArticle;

    global Knowledge__ka () 
    {
    }
}