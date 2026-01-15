using Microsoft.EntityFrameworkCore;
using PSYCare.Database;
using PSYCare.Services;
using PSYCare.Services.Models;
using DbPsychologist = PSYCare.Database.Entities.Psychologist;
using DbPatient = PSYCare.Database.Entities.Patient;

namespace PSYCare.Test
{
    [TestFixture]
    // TC-PS-01 through TC-PS-06
    // - PsychologistsService: All methods
    // - PSYCareDbContext 
    // - DbPsychologist (DB entities) and Psychologist (service model)
    public class PsychologistsTests
    {
        private PSYCareDbContext _context;
        private PsychologistsService _service;

        [SetUp]
        public void Setup()
        {
            var options = new DbContextOptionsBuilder<PSYCareDbContext>()
                .UseInMemoryDatabase(databaseName: $"PsychologistsTestDb_{Guid.NewGuid()}")
                .Options;

            _context = new PSYCareDbContext(options);

            _context.Psychologists.RemoveRange(_context.Psychologists);
            _context.Patients.RemoveRange(_context.Patients);
            _context.SaveChanges();

            _service = new PsychologistsService(_context);
        }

        [TearDown]
        public void TearDown() => _context.Dispose();

        // TC-PS-01: Create Psychologist - Success
        [Test]
        public async Task CreatePsychologistAsync_ShouldReturnCreatedPsychologist()
        {
            // Arrange
            var psy = new Psychologist
            {
                Name = "Dr. Smith",
                Email = "drsmith@test.com",
                Location = "City",
                Password = "pass123"
            };

            // Act
            var result = await _service.CreatePsychologistAsync(psy);

            // Assert
            Assert.IsNotNull(result);
            Assert.AreEqual(psy.Email, result.Email);
            Assert.AreEqual(psy.Name, result.Name);
            Assert.Greater(result.Id, 0);
        }

        // TC-PS-02: Get Psychologist By ID - Existing Psychologist
        [Test]
        public async Task GetPsychologistByIdAsync_WithExistingPsychologist_ReturnsPsychologist()
        {
            // Arrange
            var dbPsy = new DbPsychologist
            {
                Name = "Dr. Jane",
                Email = "drjane@test.com",
                Location = "Town",
                Password = "abcd"
            };
            _context.Psychologists.Add(dbPsy);
            await _context.SaveChangesAsync();

            // Act
            var result = await _service.GetPsychologistByIdAsync(dbPsy.Id);

            // Assert
            Assert.IsNotNull(result);
            Assert.AreEqual(dbPsy.Email, result.Email);
            Assert.AreEqual(dbPsy.Name, result.Name);
        }

        // TC-PS-03: Get Psychologist By ID - Non-Existing Psychologist
        [Test]
        public async Task GetPsychologistByIdAsync_WithNonExistingPsychologist_ReturnsNull()
        {
            // Act
            var result = await _service.GetPsychologistByIdAsync(999);

            // Assert
            Assert.IsNull(result);
        }

        // TC-PS-04: Get All Psychologists - Returns List
        [Test]
        public async Task GetAllPsychologistsAsync_ReturnsAllPsychologists()
        {
            // Arrange
            var psy1 = new DbPsychologist
            {
                Name = "Dr. Anderson",
                Email = "anderson@test.com",
                Location = "City A",
                Password = "pass1"
            };
            var psy2 = new DbPsychologist
            {
                Name = "Dr. Brown",
                Email = "brown@test.com",
                Location = "City B",
                Password = "pass2"
            };
            var psy3 = new DbPsychologist
            {
                Name = "Dr. Clark",
                Email = "clark@test.com",
                Location = "City C",
                Password = "pass3"
            };
            _context.Psychologists.AddRange(psy1, psy2, psy3);
            await _context.SaveChangesAsync();

            // Act
            var result = await _service.GetAllPsychologistsAsync();

            // Assert
            Assert.IsNotNull(result);
            Assert.AreEqual(3, result.Count);
            Assert.IsTrue(result.Any(p => p.Email == "anderson@test.com"));
            Assert.IsTrue(result.Any(p => p.Email == "brown@test.com"));
            Assert.IsTrue(result.Any(p => p.Email == "clark@test.com"));
        }

        // TC-PS-05: Get All Psychologists - Empty List
        [Test]
        public async Task GetAllPsychologistsAsync_WithNoPsychologists_ReturnsEmptyList()
        {
            // Act
            var result = await _service.GetAllPsychologistsAsync();

            // Assert
            Assert.IsNotNull(result);
            Assert.AreEqual(0, result.Count);
        }

        // TC-PS-06: Get Patients For Psychologist - Returns Patients
        [Test]
        public async Task GetPatientsForPsychologist_WithAssignedPatients_ReturnsList()
        {
            // Arrange
            var psychologist = new DbPsychologist
            {
                Name = "Dr. Thompson",
                Email = "thompson@test.com",
                Location = "City",
                Password = "pass123"
            };
            _context.Psychologists.Add(psychologist);
            await _context.SaveChangesAsync();

            var patient1 = new DbPatient
            {
                Name = "Patient One",
                Email = "patient1@test.com",
                PhoneNumber = "111111111",
                Location = "Location1",
                Age = 25,
                IssueDescription = "Anxiety",
                Password = "pass",
                PsychologistId = psychologist.Id
            };
            var patient2 = new DbPatient
            {
                Name = "Patient Two",
                Email = "patient2@test.com",
                PhoneNumber = "222222222",
                Location = "Location2",
                Age = 30,
                IssueDescription = "Depression",
                Password = "pass",
                PsychologistId = psychologist.Id
            };
            _context.Patients.AddRange(patient1, patient2);
            await _context.SaveChangesAsync();

            // Act
            var result = await _service.GetPatientsForPsychologist(psychologist.Id);

            // Assert
            Assert.IsNotNull(result);
            Assert.AreEqual(2, result.Count);
            Assert.IsTrue(result.Any(p => p.Email == "patient1@test.com"));
            Assert.IsTrue(result.Any(p => p.Email == "patient2@test.com"));
        }

        // TC-PS-07: Get Patients For Psychologist - No Patients
        [Test]
        public async Task GetPatientsForPsychologist_WithNoPatients_ReturnsNull()
        {
            // Arrange
            var psychologist = new DbPsychologist
            {
                Name = "Dr. Empty",
                Email = "empty@test.com",
                Location = "City",
                Password = "pass123"
            };
            _context.Psychologists.Add(psychologist);
            await _context.SaveChangesAsync();

            // Act
            var result = await _service.GetPatientsForPsychologist(psychologist.Id);

            // Assert
            Assert.IsNull(result);
        }

        // TC-PS-08: Get Patients For Psychologist - Non-Existing Psychologist
        [Test]
        public async Task GetPatientsForPsychologist_WithNonExistingPsychologist_ReturnsNull()
        {
            // Act
            var result = await _service.GetPatientsForPsychologist(999);

            // Assert
            Assert.IsNull(result);
        }

        // TC-PS-09: Get Patients For Psychologist - Filter Only Assigned Patients
        [Test]
        public async Task GetPatientsForPsychologist_ReturnsOnlyAssignedPatients()
        {
            // Arrange
            var psychologist1 = new DbPsychologist
            {
                Name = "Dr. First",
                Email = "first@test.com",
                Location = "City",
                Password = "pass123"
            };
            var psychologist2 = new DbPsychologist
            {
                Name = "Dr. Second",
                Email = "second@test.com",
                Location = "City",
                Password = "pass123"
            };
            _context.Psychologists.AddRange(psychologist1, psychologist2);
            await _context.SaveChangesAsync();

            var patient1 = new DbPatient
            {
                Name = "Patient A",
                Email = "patientA@test.com",
                PhoneNumber = "111111111",
                Location = "Location1",
                Age = 25,
                IssueDescription = "Test",
                Password = "pass",
                PsychologistId = psychologist1.Id
            };
            var patient2 = new DbPatient
            {
                Name = "Patient B",
                Email = "patientB@test.com",
                PhoneNumber = "222222222",
                Location = "Location2",
                Age = 30,
                IssueDescription = "Test",
                Password = "pass",
                PsychologistId = psychologist2.Id
            };
            var patient3 = new DbPatient
            {
                Name = "Patient C",
                Email = "patientC@test.com",
                PhoneNumber = "333333333",
                Location = "Location3",
                Age = 35,
                IssueDescription = "Test",
                Password = "pass",
                PsychologistId = null
            };
            _context.Patients.AddRange(patient1, patient2, patient3);
            await _context.SaveChangesAsync();

            // Act
            var result = await _service.GetPatientsForPsychologist(psychologist1.Id);

            // Assert
            Assert.IsNotNull(result);
            Assert.AreEqual(1, result.Count);
            Assert.AreEqual("patientA@test.com", result[0].Email);
        }
    }
}