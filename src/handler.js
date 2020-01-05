module.exports.start = (event) => {
  console.log('Triggered event!');
  console.log('Event:', JSON.stringify(event, null, 2));
};