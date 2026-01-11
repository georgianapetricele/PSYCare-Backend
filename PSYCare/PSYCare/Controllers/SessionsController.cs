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
        public async Task<ActionResult<SessionResponseDto>> CreateSession([FromBody] SessionCreateDto dto)
        {
            try
            {
                var created = await _sessionService.CreateAsync(dto);
                return CreatedAtAction(nameof(GetSession), new { sessionId = created.Id }, created);
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(ex.Message);
            }
            catch (ArgumentException ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet("{sessionId}")]
        public async Task<ActionResult<SessionResponseDto>> GetSession(int sessionId)
        {
            try
            {
                var session = await _sessionService.GetByIdAsync(sessionId);
                return Ok(session);
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(ex.Message);
            }
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
            try
            {
                await _sessionService.ConfirmSessionAsync(sessionId);
                return NoContent();
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(ex.Message);
            }
        }

        [HttpPut("{sessionId}/cancel")]
        public async Task<IActionResult> CancelSession(int sessionId)
        {
            try
            {
                await _sessionService.CancelSessionAsync(sessionId);
                return NoContent();
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(ex.Message);
            }
        }
    }
}