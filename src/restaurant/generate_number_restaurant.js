export default function generateRandomPhoneNumber() {
  let phoneNumber = "+7";
  for (let i = 0; i <= 6; i++) {
    phoneNumber += Math.floor(Math.random() * 10);
  }
  return phoneNumber;
}
