recursiveRefesh();
document.getElementById("fetchTabsButton").addEventListener("click", fetchTabs);

function recursiveRefesh() {
    fetchTabs();
    setTimeout(recursiveRefesh, 5000);
}

function fetchTabs() {
    console.log("fetching tabs");
    fetch('http://localhost:7474/tabs', {mode: 'no-cors'})
        .then(response => {
            console.log(response);
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            const tabsPerDevice = document.getElementById('tabList');
            while (tabsPerDevice.firstChild) {
                tabsPerDevice.removeChild(tabsPerDevice.firstChild);
            }

            data.forEach(device => {
                const deviceName = document.createElement('h2');
                deviceName.textContent = device.name;
                deviceName.className = 'deviceName';

                tabsPerDevice.appendChild(deviceName)
                const tabs = document.createElement('ul');

                device.tabs.forEach(tab => {
                    const listItem = document.createElement('li');
                    const link = document.createElement('a');
                    link.href = tab.rawURL;
                    link.textContent = tab.title;
                    link.className = 'cardButton'; // Apply the card button class

                    link.addEventListener('click', function (e) {
                        e.preventDefault();
                        window.open(tab.rawURL, '_blank');
                    });

                    listItem.appendChild(link);
                    tabs.appendChild(listItem);
                });
                tabsPerDevice.appendChild(tabs)
            });
        })
        .catch(error => {
            console.error('There was a problem with the fetch operation:', error);
        });
}

