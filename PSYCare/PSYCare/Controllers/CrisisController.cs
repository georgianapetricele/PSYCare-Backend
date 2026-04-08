using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PSYCare.Services;
using PSYCare.Services.Interfaces;
using System.Net.WebSockets;

namespace PSYCare.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class CrisisController : ControllerBase
    {
        private readonly ICrisisService _crisisService;

        public CrisisController(ICrisisService crisisService)
        {
            _crisisService = crisisService;
        }

        [HttpPost]
        [Route("crisis/{pacientId}")]
        public async Task<IActionResult> Crisis(int pacientId)
        {
            if (!await _crisisService.NotifyPsychologistOfCrisisAsync(pacientId))
            {
                return NotFound();
            }

            return Ok(new { message = "Psychologist notified via WebSocket" });
        }
    }
}