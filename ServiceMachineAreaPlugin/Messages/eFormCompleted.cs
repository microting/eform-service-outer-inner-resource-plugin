namespace ServiceMachineAreaPlugin.Messages
{
    public class eFormCompleted
    {
        public string caseId { get; protected set; }

        public eFormCompleted(string caseId)
        {
            this.caseId = caseId;
        }
    }
}