namespace ServiceMachineAreaPlugin.Messages
{
    public class CheckAllCases
    {
        public int eFormId { get; }

        public CheckAllCases(int eFormId)
        {
            this.eFormId = eFormId;
        }
    }
}