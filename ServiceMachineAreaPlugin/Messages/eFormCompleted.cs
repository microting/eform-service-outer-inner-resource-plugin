namespace ServiceMachineAreaPlugin.Messages
{
    public class eFormCompleted
    {
        public string MicrotingUUID { get; protected set; }

        public eFormCompleted(string microtingUId)
        {
            this.MicrotingUUID = microtingUId;
        }
    }
}