namespace PSYCare.Services.Interfaces
{
    public interface ICrisisService
    {
        Task<bool> NotifyPsychologistOfCrisisAsync(int patientId);
    }
}
