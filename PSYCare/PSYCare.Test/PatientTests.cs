using Microsoft.EntityFrameworkCore;
using PSYCare.Database;
using PSYCare.Services;
using PSYCare.Services.Models;
using DbPatient = PSYCare.Database.Entities.Patient;
using DbPsychologist = PSYCare.Database.Entities.Psychologist;

namespace PSYCare.Test
{
    [TestFixture]
    // TC-P-01 through TC-P-08
    // - PatientsService: All methods
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
                .UseInMemoryDatabase(databaseName: $"PatientsTestDb_{Guid.NewGuid()}")
                .Options;

            _context = new PSYCareDbContext(options);

            _context.Patients.RemoveRange(_context.Patients);
            _context.Psychologists.RemoveRange(_context.Psychologists);
            _context.SaveChanges();

            _patientsService = new PatientsService(_context);
        }

        [TearDown]
        public void TearDown()
        {
            _context.Dispose();
        }

        // TC-P-01: Create Patient - Success
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
            Assert.Greater(result.Id, 0);
        }

        // TC-P-02: Get Patient By ID - Existing Patient
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

        // TC-P-03: Get Patient By ID - Non-Existing Patient
        [Test]
        public async Task GetPatientByIdAsync_WithNonExistingPatient_ReturnsNull()
        {
            // Act
            var result = await _patientsService.GetPatientByIdAsync(999);

            // Assert
            Assert.IsNull(result);
        }

        // TC-P-04: Update Patient - Success
        [Test]
        public async Task UpdatePatientAsync_WithValidData_ReturnsUpdatedPatient()
        {
            // Arrange
            var dbPatient = new DbPatient
            {
                Name = "Test Patient",
                Email = "test@test.com",
                PhoneNumber = "111111111",
                Location = "Location",
                Age = 28,
                IssueDescription = "Depression",
                Password = "pass"
            };
            _context.Patients.Add(dbPatient);
            await _context.SaveChangesAsync();

            // Act
            var result = await _patientsService.UpdatePatientAsync(
                dbPatient.Id, 
                "Major Depressive Disorder", 
                "Patient shows improvement"
            );

            // Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("Major Depressive Disorder", result.Diagnosis);
            Assert.AreEqual("Patient shows improvement", result.PsychologistNotes);
        }

        // TC-P-05: Update Patient - Non-Existing Patient
        [Test]
        public async Task UpdatePatientAsync_WithNonExistingPatient_ReturnsNull()
        {
            // Act
            var result = await _patientsService.UpdatePatientAsync(999, "Diagnosis", "Notes");

            // Assert
            Assert.IsNull(result);
        }

        // TC-P-06: Delete Patient - Success
        [Test]
        public async Task DeletePatientAsync_WithExistingPatient_ReturnsTrue()
        {
            // Arrange
            var psychologist = new DbPsychologist
            {
                Name = "Dr. Smith",
                Email = "dr.smith@test.com",
                Location = "City",
                Password = "pass123"
            };
            _context.Psychologists.Add(psychologist);
            await _context.SaveChangesAsync();

            var dbPatient = new DbPatient
            {
                Name = "Patient To Delete",
                Email = "delete@test.com",
                PhoneNumber = "555555555",
                Location = "City",
                Age = 35,
                IssueDescription = "Test",
                Password = "pass",
                PsychologistId = psychologist.Id
            };
            _context.Patients.Add(dbPatient);
            await _context.SaveChangesAsync();

            // Act
            var result = await _patientsService.DeletePatientAsync(dbPatient.Id);

            // Assert
            Assert.IsTrue(result);
            
            // Verify psychologist was unassigned
            var updatedPatient = await _context.Patients.FindAsync(dbPatient.Id);
            Assert.IsNull(updatedPatient.PsychologistId);
        }

        // TC-P-07: Delete Patient - Non-Existing Patient
        [Test]
        public async Task DeletePatientAsync_WithNonExistingPatient_ReturnsFalse()
        {
            // Act
            var result = await _patientsService.DeletePatientAsync(999);

            // Assert
            Assert.IsFalse(result);
        }

        // TC-P-08: Assign Psychologist - Success
        [Test]
        public async Task AssignPsychologistToPatientAsync_WithValidData_ReturnsTrue()
        {
            // Arrange
            var psychologist = new DbPsychologist
            {
                Name = "Dr. Johnson",
                Email = "dr.johnson@test.com",
                Location = "City",
                Password = "pass123"
            };
            _context.Psychologists.Add(psychologist);

            var patient = new DbPatient
            {
                Name = "Patient Name",
                Email = "patient@test.com",
                PhoneNumber = "123456789",
                Location = "City",
                Age = 30,
                IssueDescription = "Anxiety",
                Password = "pass"
            };
            _context.Patients.Add(patient);
            await _context.SaveChangesAsync();

            // Act
            var result = await _patientsService.AssignPsychologistToPatientAsync(
                patient.Id, 
                psychologist.Email
            );

            // Assert
            Assert.IsTrue(result);
            
            // Verify assignment
            var updatedPatient = await _context.Patients.FindAsync(patient.Id);
            Assert.AreEqual(psychologist.Id, updatedPatient.PsychologistId);
        }

        // TC-P-09: Assign Psychologist - Non-Existing Patient
        [Test]
        public async Task AssignPsychologistToPatientAsync_WithNonExistingPatient_ReturnsFalse()
        {
            // Arrange
            var psychologist = new DbPsychologist
            {
                Name = "Dr. Test",
                Email = "dr.test@test.com",
                Location = "City",
                Password = "pass123"
            };
            _context.Psychologists.Add(psychologist);
            await _context.SaveChangesAsync();

            // Act
            var result = await _patientsService.AssignPsychologistToPatientAsync(
                999, 
                psychologist.Email
            );

            // Assert
            Assert.IsFalse(result);
        }

        // TC-P-10: Assign Psychologist - Non-Existing Psychologist
        [Test]
        public async Task AssignPsychologistToPatientAsync_WithNonExistingPsychologist_ReturnsFalse()
        {
            // Arrange
            var patient = new DbPatient
            {
                Name = "Patient Name",
                Email = "patient@test.com",
                PhoneNumber = "123456789",
                Location = "City",
                Age = 30,
                IssueDescription = "Anxiety",
                Password = "pass"
            };
            _context.Patients.Add(patient);
            await _context.SaveChangesAsync();

            // Act
            var result = await _patientsService.AssignPsychologistToPatientAsync(
                patient.Id, 
                "nonexistent@test.com"
            );

            // Assert
            Assert.IsFalse(result);
        }

        // TC-P-11: Get Psychologist For Patient - Success
        [Test]
        public async Task GetPsychologistForPatientAsync_WithAssignedPsychologist_ReturnsPsychologist()
        {
            // Arrange
            var psychologist = new DbPsychologist
            {
                Name = "Dr. Williams",
                Email = "dr.williams@test.com",
                Location = "City Center",
                Password = "pass123"
            };
            _context.Psychologists.Add(psychologist);

            var patient = new DbPatient
            {
                Name = "Patient Name",
                Email = "patient@test.com",
                PhoneNumber = "123456789",
                Location = "City",
                Age = 30,
                IssueDescription = "Anxiety",
                Password = "pass"
            };
            _context.Patients.Add(patient);
            await _context.SaveChangesAsync();

            patient.PsychologistId = psychologist.Id;
            await _context.SaveChangesAsync();

            // Act
            var result = await _patientsService.GetPsychologistForPatientAsync(patient.Id);

            // Assert
            Assert.IsNotNull(result);
            Assert.AreEqual(psychologist.Email, result.Email);
            Assert.AreEqual(psychologist.Name, result.Name);
            Assert.AreEqual(psychologist.Location, result.Location);
        }

        // TC-P-12: Get Psychologist For Patient - No Psychologist Assigned
        [Test]
        public async Task GetPsychologistForPatientAsync_WithNoPsychologistAssigned_ReturnsNull()
        {
            // Arrange
            var patient = new DbPatient
            {
                Name = "Patient Name",
                Email = "patient@test.com",
                PhoneNumber = "123456789",
                Location = "City",
                Age = 30,
                IssueDescription = "Anxiety",
                Password = "pass",
                PsychologistId = null
            };
            _context.Patients.Add(patient);
            await _context.SaveChangesAsync();

            // Act
            var result = await _patientsService.GetPsychologistForPatientAsync(patient.Id);

            // Assert
            Assert.IsNull(result);
        }
    }
}

