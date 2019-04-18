namespace ServiceMachineAreaPlugin.Messages
{
    public class eFormCompleted
    {
        public string caseId { get; protected set; }
        public string checkId { get; protected set; }

        public eFormCompleted(string caseId, string checkId)
        {
            this.caseId = caseId;
            this.checkId = checkId;
        }
    }
}