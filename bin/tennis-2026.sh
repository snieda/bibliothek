curl -s 'https://kurse.zhs-muenchen.de/de/product-offers/21114da0-4246-42b1-bab6-8d7ac49bb14f?refinementList%5Btags.Standort%5D%5B0%5D=Beach-+und+Tennisanlage' \
| grep -oE 'src="[^"]+"' \
| cut -d'"' -f2

curl -s 'https://kurse.zhs-muenchen.de/services/booking/fragments/product-offer-details/dist/assets/index-DDdvrjoD.js' > app.js

grep -aoE 'https://[^"]+|/api/[^"]+|graphql|bookings|availability|slot[s]?' app.js | sort -u

grep -aoE '/[^"]*(graphql|api)[^"]*' app.js | sort -u