namespace ServiceMachineAreaPlugin.Messages
{
    public class eFormCompleted
    {
        public string A { get; protected set; }
        public string B { get; protected set; }

        public eFormCompleted(string microtingUId, string checkUId)
        {
            A = microtingUId;
            B = checkUId;
        }
    }
}