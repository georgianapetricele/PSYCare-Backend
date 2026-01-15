// SessionTests.cs
using Microsoft.EntityFrameworkCore;
using PSYCare.Controllers.Models;
using PSYCare.Database;
using PSYCare.Database.Entities;
using PSYCare.Services;

namespace PSYCare.Test
{
    [TestFixture]
    // TC-S-01, TC-S-02, TC-S-03, TC-S-04, TC-S-05, TC-S-06, TC-S-07
    // - SessionService methods: CreateAsync, GetByPatientIdAsync, GetByPsychologistIdAsync, 
    //   GetByIdAsync, ConfirmSessionAsync, CancelSessionAsync
    // - PSYCareDbContext for Patients, Psychologists and Sessions
    // - Validates behavior: creation, listing, retrieval, status updates, ordering
    internal class SessionTests
    {
        private PSYCareDbContext _context;
        private SessionService _service;

        [SetUp]
        public void Setup()
        {
            var options = new DbContextOptionsBuilder<PSYCareDbContext>()
                .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
                .Options;

            _context = new PSYCareDbContext(options);

            _context.Sessions.RemoveRange(_context.Sessions);
            _context.Patients.RemoveRange(_context.Patients);
            _context.Psychologists.RemoveRange(_context.Psychologists);
            _context.SaveChanges();

            // Add test data
            _context.Patients.Add(new Patient 
            { 
                Id = 1, 
                Email = "patient@test.com", 
                Name = "Test Patient", 
                Password = "pass123", 
                PhoneNumber = "1234567890",
                Age = 30,
                Location = "Test City",
                IssueDescription = "Test issue"
            });

            _context.Psychologists.Add(new Psychologist 
            { 
                Id = 1, 
                Email = "psychologist@test.com", 
                Name = "Dr. Test", 
                Password = "pass123",
                Location = "Test City"
            });

            _context.SaveChanges();

            _service = new SessionService(_context);
        }

        [TearDown]
        public void TearDown() => _context.Dispose();

        [Test]
        public async Task CreateAsync_ShouldCreateSession()
        {
            var dto = new SessionCreateDto
            {
                PatientId = 1,
                PsychologistId = 1,
                ScheduledAt = DateTime.UtcNow.AddDays(1),
                Notes = "First session",
                Status = "pending"
            };

            var result = await _service.CreateAsync(dto);

            Assert.IsNotNull(result);
            Assert.AreEqual(dto.PatientId, result.PatientId);
            Assert.AreEqual(dto.PsychologistId, result.PsychologistId);
            Assert.AreEqual(dto.Status, result.Status);
            Assert.AreEqual(dto.Notes, result.Notes);
        }

        [Test]
        public void CreateAsync_InvalidPatientId_ThrowsKeyNotFoundException()
        {
            var dto = new SessionCreateDto
            {
                PatientId = 999,
                PsychologistId = 1,
                ScheduledAt = DateTime.UtcNow.AddDays(1),
                Status = "pending"
            };

            Assert.ThrowsAsync<KeyNotFoundException>(async () =>
            {
                await _service.CreateAsync(dto);
            });
        }

        [Test]
        public async Task GetByPatientIdAsync_ShouldReturnPatientSessions()
        {
            _context.Sessions.AddRange(
                new Session 
                { 
                    Id = 1, 
                    PatientId = 1, 
                    PsychologistId = 1, 
                    ScheduledAt = DateTime.UtcNow.AddDays(1),
                    Status = "pending"
                },
                new Session 
                { 
                    Id = 2, 
                    PatientId = 1, 
                    PsychologistId = 1, 
                    ScheduledAt = DateTime.UtcNow.AddDays(2),
                    Status = "confirmed"
                }
            );
            _context.SaveChanges();

            var result = await _service.GetByPatientIdAsync(1);

            Assert.AreEqual(2, result.Count);
            Assert.IsTrue(result.All(s => s.PatientId == 1));
        }

        [Test]
        public async Task GetByIdAsync_ShouldReturnSession()
        {
            _context.Sessions.Add(new Session
            {
                Id = 1,
                PatientId = 1,
                PsychologistId = 1,
                ScheduledAt = DateTime.UtcNow.AddDays(1),
                Status = "pending",
                Notes = "Test session"
            });
            _context.SaveChanges();

            var result = await _service.GetByIdAsync(1);

            Assert.IsNotNull(result);
            Assert.AreEqual(1, result.Id);
            Assert.AreEqual("pending", result.Status);
            Assert.AreEqual("Test session", result.Notes);
        }

        [Test]
        public async Task ConfirmSessionAsync_ShouldUpdateStatusToConfirmed()
        {
            _context.Sessions.Add(new Session
            {
                Id = 1,
                PatientId = 1,
                PsychologistId = 1,
                ScheduledAt = DateTime.UtcNow.AddDays(1),
                Status = "pending",
            });
            _context.SaveChanges();

            await _service.ConfirmSessionAsync(1);

            var updated = await _context.Sessions.FindAsync(1);
            Assert.AreEqual("confirmed", updated.Status);
        }

        [Test]
        public async Task CancelSessionAsync_ShouldUpdateStatusToCancelled()
        {
            _context.Sessions.Add(new Session
            {
                Id = 1,
                PatientId = 1,
                PsychologistId = 1,
                ScheduledAt = DateTime.UtcNow.AddDays(1),
                Status = "pending",
            });
            _context.SaveChanges();

            await _service.CancelSessionAsync(1);

            var updated = await _context.Sessions.FindAsync(1);
            Assert.AreEqual("cancelled", updated.Status);
        }

        [Test]
        public async Task GetByPsychologistIdAsync_ShouldReturnOrderedSessions()
        {
            _context.Sessions.AddRange(
                new Session
                {
                    Id = 1,
                    PatientId = 1,
                    PsychologistId = 1,
                    ScheduledAt = DateTime.UtcNow.AddDays(3),
                    Status = "pending"
                },
                new Session
                {
                    Id = 2,
                    PatientId = 1,
                    PsychologistId = 1,
                    ScheduledAt = DateTime.UtcNow.AddDays(1),
                    Status = "pending",
                }
            );
            _context.SaveChanges();

            var result = await _service.GetByPsychologistIdAsync(1);

            Assert.AreEqual(2, result.Count);
            Assert.IsTrue(result[0].ScheduledAt < result[1].ScheduledAt);
        }
    }
}