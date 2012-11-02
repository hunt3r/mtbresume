
module Jekyll

  class SiteCreateAllContentCollection < Jekyll::Generator
   	safe true

    def generate(site)
        config = site.config

        if !config['all_content']
            all_content = []
            site.site_payload["site"]["pages"].each { |page| 
              pageHash = page.data
              liquid_page = page.to_liquid
              pageHash['url'] ||= liquid_page["url"]
              pageHash['content'] ||= page.content
              pageHash['tags'] ||= page.data.has_key?('tags') ? page.data['tags'] : []
              pageHash['sort'] ||= page.data.has_key?('sort') ? page.data['sort'] : 0
              all_content.push(pageHash)
            }

            site.site_payload["site"]["posts"].each { |post| 
              postHash = post.data
              postHash['url'] ||= post.url
              postHash['content'] ||= post.content
              postHash['tags'] ||= post.data.has_key?('tags') ? post.data['tags'] : []
              postHash['sort'] ||= post.data.has_key?('sort') ? post.data['sort'] : 0
              all_content.push(postHash)
            }
            
            # Access this in Liquid using: site.all_content
            site.config["all_content"] = all_content
        end


    end
  end
end