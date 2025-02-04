const express = require('express');
const awsServerlessExpress = require('aws-serverless-express');

const app = express();
app.use(express.json());

// In-memory data store (replace with a database in production)
let appointments = [
  { id: '1', patientId: '1', date: '2023-06-15', time: '10:00', doctor: 'Dr. Smith' },
  { id: '2', patientId: '2', date: '2023-06-16', time: '14:30', doctor: 'Dr. Johnson' }
];

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'OK', service: 'Appointment Service' });
});

// Get all appointments
app.get('/appointments', (req, res) => {
  res.json({
    message: 'Appointments retrieved successfully',
    count: appointments.length,
    appointments
  });
});

// Get appointment by ID
app.get('/appointments/:id', (req, res) => {
  const appointment = appointments.find(a => a.id === req.params.id);
  if (appointment) {
    res.json({ message: 'Appointment found', appointment });
  } else {
    res.status(404).json({ error: 'Appointment not found' });
  }
});

// Create a new appointment
app.post('/appointments', (req, res) => {
  try {
    const { patientId, date, time, doctor } = req.body;
    if (!patientId || !date || !time || !doctor) {
      return res.status(400).json({ error: 'Patient ID, date, time, and doctor are required' });
    }
    const newAppointment = {
      id: (appointments.length + 1).toString(),
      patientId,
      date,
      time,
      doctor
    };
    appointments.push(newAppointment);
    res.status(201).json({ message: 'Appointment scheduled successfully', appointment: newAppointment });
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get appointments by patient ID
app.get('/appointments/patient/:patientId', (req, res) => {
  try {
    const patientId = req.params.patientId;
    const patientAppointments = appointments.filter(appt => appt.patientId === patientId);
    if (patientAppointments.length > 0) {
      res.json({ message: `Found ${patientAppointments.length} appointment(s)`, appointments: patientAppointments });
    } else {
      res.status(404).json({ message: `No appointments found for patient ${patientId}` });
    }
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Create Lambda server
const server = awsServerlessExpress.createServer(app);

// Lambda handler
exports.handler = (event, context) => {
  console.log('Incoming event:', JSON.stringify(event, null, 2)); // Log event for debugging
  awsServerlessExpress.proxy(server, event, context);
};
