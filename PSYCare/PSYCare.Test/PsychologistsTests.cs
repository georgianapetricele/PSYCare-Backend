using Microsoft.EntityFrameworkCore;
using PSYCare.Database;
using PSYCare.Services;
using PSYCare.Services.Models;
using DbPsychologist = PSYCare.Database.Entities.Psychologist;
namespace PSYCare.Test
{
    [TestFixture]
    // TC-PS-01, TC-PS-02
    // - PsychologistsService: CreatePsychologistAsync, GetPsychologistByIdAsync
    // - PSYCareDbContext 
    // - DbPsychologist (DB entities) and Psychologist
    internal class PsychologistsTests
    {
        private PSYCareDbContext _context;
        private PsychologistsService _service;

        [SetUp]
        public void Setup()
        {
            var options = new DbContextOptionsBuilder<PSYCareDbContext>()
                .UseInMemoryDatabase(databaseName: "PsychologistsTestDb")
                .Options;

            _context = new PSYCareDbContext(options);

            _context.Psychologists.RemoveRange(_context.Psychologists);
            _context.Patients.RemoveRange(_context.Patients);
            _context.SaveChanges();

            _service = new PsychologistsService(_context);
        }

        [TearDown]
        public void TearDown() => _context.Dispose();

        [Test]
        public async Task CreatePsychologistAsync_ShouldReturnCreatedPsychologist()
        {
            var psy = new Psychologist
            {
                Name = "Dr. Smith",
                Email = "drsmith@test.com",
                Location = "City",
                Password = "pass123"
            };

            var result = await _service.CreatePsychologistAsync(psy);

            Assert.IsNotNull(result);
            Assert.AreEqual(psy.Email, result.Email);
            Assert.AreEqual(psy.Name, result.Name);
        }

        [Test]
        public async Task GetPsychologistByIdAsync_WithExistingPsychologist_ReturnsPsychologist()
        {
            var dbPsy = new DbPsychologist
            {
                Name = "Dr. Jane",
                Email = "drjane@test.com",
                Location = "Town",
                Password = "abcd"
            };
            _context.Psychologists.Add(dbPsy);
            await _context.SaveChangesAsync();

            var result = await _service.GetPsychologistByIdAsync(dbPsy.Id);

            Assert.IsNotNull(result);
            Assert.AreEqual(dbPsy.Email, result.Email);
            Assert.AreEqual(dbPsy.Name, result.Name);
        }
        
    }
}

