using Microsoft.EntityFrameworkCore;
using PSYCare.Database;
using PSYCare.Services;
using PSYCare.Services.Models;
using DbPatient = PSYCare.Database.Entities.Patient;

namespace PSYCare.Test
{
    [TestFixture]
    // TC-P-01, TC-P-02, TC-P-03
    // - PatientsService: CreatePatientAsync and GetPatientByIdAsync logic
    // - PSYCareDbContext 
    // - DbPatient (DB entity) and Patient (service model)
    public class PatientTests
    {
        private PSYCareDbContext _context;
        private PatientsService _patientsService;

        [SetUp]
        public void Setup()
        {
            var options = new DbContextOptionsBuilder<PSYCareDbContext>()
                .UseInMemoryDatabase(databaseName: "PatientsTestDb")
                .Options;

            _context = new PSYCareDbContext(options);

            _context.Patients.RemoveRange(_context.Patients);
            _context.SaveChanges();

            _patientsService = new PatientsService(_context);
        }

        [TearDown]
        public void TearDown()
        {
            _context.Dispose();
        }

        [Test]
        public async Task CreatePatientAsync_ShouldReturnCreatedPatient()
        {
            // Arrange
            var patient = new Patient
            {
                Name = "John Doe",
                Email = "john@test.com",
                PhoneNumber = "123456789",
                Location = "City",
                Age = 30,
                IssueDescription = "Stress",
                Password = "1234"
            };

            // Act
            var result = await _patientsService.CreatePatientAsync(patient);

            // Assert
            Assert.IsNotNull(result);
            Assert.AreEqual(patient.Email, result.Email);
            Assert.AreEqual(patient.Name, result.Name);
        }

        [Test]
        public async Task GetPatientByIdAsync_WithExistingPatient_ReturnsPatient()
        {
            // Arrange
            var dbPatient = new DbPatient
            {
                Name = "Jane Doe",
                Email = "jane@test.com",
                PhoneNumber = "987654321",
                Location = "Town",
                Age = 25,
                IssueDescription = "Anxiety",
                Password = "abcd"
            };
            _context.Patients.Add(dbPatient);
            await _context.SaveChangesAsync();

            // Act
            var result = await _patientsService.GetPatientByIdAsync(dbPatient.Id);

            // Assert
            Assert.IsNotNull(result);
            Assert.AreEqual(dbPatient.Email, result.Email);
            Assert.AreEqual(dbPatient.Name, result.Name);
        }

        [Test]
        public async Task GetPatientByIdAsync_WithNonExistingPatient_ReturnsNull()
        {
            // Act
            var result = await _patientsService.GetPatientByIdAsync(999);

            // Assert
            Assert.IsNull(result);
        }
    }
}

