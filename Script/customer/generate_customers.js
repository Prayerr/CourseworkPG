const {
  firstNameMan,
  lastNameMan,
  firstNameWoman,
  lastNameWoman,
} = require("./names");

function getRandomElement(arr) {
  return arr[Math.floor(Math.random() * arr.length)];
}

function generateRandomName(gender) {
  if (gender === "man") {
    const firstName = getRandomElement(firstNameMan);
    const lastName = getRandomElement(lastNameMan);

    return `${firstName} ${lastName}`;
  } else if (gender === "woman") {
    const firstName = getRandomElement(firstNameWoman);
    const lastName = getRandomElement(lastNameWoman);

    return `${firstName} ${lastName}`;
  } else {
    return null;
  }
}

function generateRandomPhoneNumber() {
  let phoneNumber = "+7";
  for (let i = 0; i <= 9; i++) {
    phoneNumber += Math.floor(Math.random() * 10);
  }
  return phoneNumber;
}

const generatedNames = { male: [], female: [] };

while (generatedNames.male.length <= 15) {
  const fullName = generateRandomName("man");
  if (
    !generatedNames.male.includes(fullName) ||
    generatedNames.male.filter((n) => n === fullName).length < 2
  ) {
    generatedNames.male.push(fullName);
    const phoneNumber = generateRandomPhoneNumber();
    console.log(
      `INSERT INTO customer (name, customer_phone) VALUES ('${fullName}', '${phoneNumber}');`
    );
  }
}

while (generatedNames.female.length <= 15) {
  const fullName = generateRandomName("woman");
  if (
    !generatedNames.female.includes(fullName) ||
    generatedNames.female.filter((n) => n === fullName).length < 2
  ) {
    generatedNames.female.push(fullName);
    const phoneNumber = generateRandomPhoneNumber();
    console.log(
      `INSERT INTO customer (name, customer_phone) VALUES ('${fullName}', '${phoneNumber}');`
    );
  }
}
