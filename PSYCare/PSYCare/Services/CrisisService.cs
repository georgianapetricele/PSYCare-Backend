using PSYCare.Services.Interfaces;

namespace PSYCare.Services
{
    public class CrisisService(IPatientsService patientsService, IWebSocketService webSocketService) : ICrisisService
    {
        private readonly IPatientsService _patientsService = patientsService;
        private readonly IWebSocketService _webSocketService = webSocketService;

        public async Task<bool> NotifyPsychologistOfCrisisAsync(int patientId)
        {
            var patient = await _patientsService.GetPatientByIdAsync(patientId);
            if (patient is null) return false;

            if (patient.PsychologistId.HasValue)
            {
                var message = $"Pacient {patient.Name} has pressed the crisis button! Give your pacient a call: {patient.PhoneNumber}";
                await _webSocketService.SendNotificationAsync(patient.PsychologistId.Value, message);
            }

            return true;
        }
    }
}