Experiments and Observations
1. Effect of Adding Additional URI Parameters as Part of the POST Route
Experiment: Add additional URI parameters to the form action URL.
<form action="http://localhost:8081?extra=param" method="POST">
Observation: When you submit the form, Netcat will show the POST request. The additional URI parameters (?extra=param) will be included in the request line, but the form data will still be sent in the body of the request.

2. Effect of Changing the Name Properties of the Form Fields
Experiment: Change the name attributes of the form fields.
<input type="text" id="name" name="username">
<input type="text" id="age" name="userage">
Observation: When you submit the form, the form data will be sent with the new name attributes. For example, the data will be sent as username=somevalue&userage=somevalue.

3. Multiple Submit Buttons
Experiment: Add multiple submit buttons with different name attributes.
<input type="submit" name="submit1" value="Submit 1">
<input type="submit" name="submit2" value="Submit 2">
Observation: When you click a submit button, the form data will include the name and value of the clicked button. For example, if you click "Submit 1", the data will include submit1=Submit+1.

4. Form Submission Using GET Instead of POST
Experiment: Change the form method to GET.
<form action="http://localhost:8081" method="GET">
Observation: When you submit the form, the form data will be appended to the URL as query parameters. For example, http://localhost:8081?name=somevalue&age=somevalue.

5. Other HTTP Verbs in Form Submit Route
Experiment: HTML forms natively support only GET and POST. To use other HTTP verbs like PUT, PATCH, or DELETE, you need to use JavaScript or a library like jQuery.
Example using JavaScript:
<form id="myForm" action="http://localhost:8081" method="POST">
    <input type="text" name="name">
    <button type="button" onclick="submitForm('PUT')">PUT</button>
    <button type="button" onclick="submitForm('DELETE')">DELETE</button>
</form>

<script>
    function submitForm(method) {
        var form = document.getElementById('myForm');
        var formData = new FormData(form);
        fetch(form.action, {
            method: method,
            body: formData
        }).then(response => response.text()).then(data => console.log(data));
    }
</script>
Observation: When you click the buttons, the JavaScript function will send the form data using the specified HTTP verb (PUT or DELETE). Netcat will show the request with the corresponding HTTP method.