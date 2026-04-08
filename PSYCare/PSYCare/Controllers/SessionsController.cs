using Microsoft.AspNetCore.Mvc;
using PSYCare.Controllers.Models;
using PSYCare.Services.Interfaces;

namespace PSYCare.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class SessionsController : ControllerBase
    {
        private readonly ISessionService _sessionService;

        public SessionsController(ISessionService sessionService)
        {
            _sessionService = sessionService;
        }

        [HttpPost]
        public async Task<IActionResult> CreateSession([FromBody] SessionCreateDto dto)
        {
            var created = await _sessionService.CreateAsync(dto);
            return CreatedAtAction(nameof(GetSession), new { sessionId = created.Id }, created);
        }

        [HttpGet("{sessionId}")]
        public async Task<ActionResult<SessionResponseDto>> GetSession(int sessionId)
        {
            var session = await _sessionService.GetByIdAsync(sessionId);
            return session;
        }

        [HttpGet("patient/{patientId}")]
        public async Task<ActionResult<IReadOnlyList<SessionResponseDto>>> GetPatientSessions(int patientId)
        {
            var sessions = await _sessionService.GetByPatientIdAsync(patientId);
            return Ok(sessions);
        }

        [HttpGet("psychologist/{psychologistId}")]
        public async Task<ActionResult<IReadOnlyList<SessionResponseDto>>> GetPsychologistSessions(int psychologistId)
        {
            var sessions = await _sessionService.GetByPsychologistIdAsync(psychologistId);
            return Ok(sessions);
        }

        [HttpPut("{sessionId}/confirm")]
        public async Task<IActionResult> ConfirmSession(int sessionId)
        {
            await _sessionService.ConfirmSessionAsync(sessionId);
            return NoContent();
        }

        [HttpPut("{sessionId}/cancel")]
        public async Task<IActionResult> CancelSession(int sessionId)
        {
            await _sessionService.CancelSessionAsync(sessionId);
            return NoContent();
        }

    }
}