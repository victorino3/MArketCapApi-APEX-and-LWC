// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class Knowledge__kav {
    global Id Id;
    global Knowledge__ka KnowledgeArticle;
    global Id KnowledgeArticleId;
    global SObject Owner;
    global Id OwnerId;
    global Boolean IsDeleted;
    global String ValidationStatus;
    global String PublishStatus;
    global Integer VersionNumber;
    global Boolean IsLatestVersion;
    global Boolean IsVisibleInApp;
    global Boolean IsVisibleInPkb;
    global Boolean IsVisibleInCsp;
    global Boolean IsVisibleInPrm;
    global Datetime CreatedDate;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime LastModifiedDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime SystemModstamp;
    global String Language;
    global String Title;
    global String UrlName;
    global String CurrencyIsoCode;
    global Datetime ArchivedDate;
    global User ArchivedBy;
    global Id ArchivedById;
    /* Briefly describe the article. The summary is used in search results to help users find relevant articles. You can improve the accuracy of search results by including phrases that your customers use to describe this issue or topic.
    */
    global String Summary;
    /* Determine when the knowledge article must next be reviewed for accuracy.
    */
    global Datetime NextReviewDate;
    global String ArticleNumber;
    global Datetime FirstPublishedDate;
    global Datetime LastPublishedDate;
    global User ArticleArchivedBy;
    global Id ArticleArchivedById;
    global Datetime ArticleArchivedDate;
    global Integer ArticleCaseAttachCount;
    global User ArticleCreatedBy;
    global Id ArticleCreatedById;
    global Datetime ArticleCreatedDate;
    global String ArticleMasterLanguage;
    global Integer ArticleTotalViewCount;
    global Case Source;
    global Id SourceId;
    global RecordType RecordType;
    global Id RecordTypeId;
    global SObject AssignedTo;
    global Id AssignedToId;
    global User AssignedBy;
    global Id AssignedById;
    global Datetime AssignmentDate;
    global Datetime AssignmentDueDate;
    global String AssignmentNote;
    global String MigratedToFromArticleVersion;
    global String Answer__c;
    global String Question__c;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<CaseArticle> CaseArticles;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<FlowOrchestrationWorkItem> FlowOrchestrationWorkItems;
    global List<Knowledge__DataCategorySelection> DataCategorySelections;
    global List<LinkedArticle> LinkedArticles;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<SearchPromotionRule> SearchPromotionRules;
    global List<TopicAssignment> TopicAssignments;
    global List<ContentDocumentLinkChangeEvent> LinkedEntity;
    global List<ContentVersion> FirstPublishLocation;
    global List<SearchActivity> ClickedRecord;

    global Knowledge__kav () 
    {
    }
}