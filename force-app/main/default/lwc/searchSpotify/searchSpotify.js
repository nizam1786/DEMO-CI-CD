import { LightningElement } from 'lwc';
import searchWithSpotify from '@salesforce/apex/SpotifyIntegration.searchWithSpotify';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class SearchSpotify extends LightningElement {
searchTracker;
displayResult= false;
trackData = '';
trackUrl = '';

changehandler(event){
 this.searchTracker = event.target.value;
}

async searchTrack(){
   let isValid = this.validateInput();
   if(isValid){
    try{
        let responseString = await searchWithSpotify({
            trackName : this.searchTracker
        })
            let response = JSON.parse(responseString);
            this.trackData = response.tracks.items[0];
            this.trackUrl = this.trackData.album.images[0].url;
            console.log(' this.trackUrl', this.trackUrl);
            this.displayResult = true;

            console.log('response', JSON.parse(JSON.stringify(response)));

    }catch(error){
         console.log(error);
         this.showToast('Error', 'Something Went wrong', 'error');
    }
   }
}
validateInput(){
   let isValid = true;
   let element = this.template.querySelector('lightning-input');
   if(!element.checkValidity()){
      element.reportValidity();
      isValid = false
   }
   return isValid;
}

showToast(title,message,variant) {
        const event = new ShowToastEvent({
            title: title,
            message:message,
            variant:variant
        });
        this.dispatchEvent(event);
    }
    get artistName(){
       let artistName = this.trackData.artists.map(currItem => currItem.name);
       let artistNameString = artistName.join(',');
       return artistNameString;
    }
}