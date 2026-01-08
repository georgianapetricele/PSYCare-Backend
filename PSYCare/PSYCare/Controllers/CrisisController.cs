using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PSYCare.Services;
using PSYCare.Services.Interfaces;
using System.Net.WebSockets;

namespace PSYCare.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class CrisisController : Controller
    {
        private readonly IPatientsService _patientsService;
        private readonly IWebSocketService _wsManager;

        public CrisisController(IPatientsService patientsService, IWebSocketService wsManager)
        {
            _patientsService = patientsService;
            _wsManager = wsManager;
        }

        [HttpPost]
        [Route("crisis/{pacientId}")]
        public async Task<IActionResult> Crisis(int pacientId)
        {
            var pacient = await _patientsService.GetPatientByIdAsync(pacientId);
            if (pacient == null) return NotFound();

            var psychologistId = pacient.PsychologistId;

            if (psychologistId.HasValue && _wsManager.TryGet(psychologistId.Value, out var ws))
            {
                var message = $"Pacient {pacient.Name} has pressed the crisis button! Give your pacient a call: {pacient.PhoneNumber}";
                var bytes = System.Text.Encoding.UTF8.GetBytes(message);
                await ws.SendAsync(new ArraySegment<byte>(bytes), WebSocketMessageType.Text, true, CancellationToken.None);
            }

            return Ok(new { message = "Psychologist notified via WebSocket" });
        }


    }
}
