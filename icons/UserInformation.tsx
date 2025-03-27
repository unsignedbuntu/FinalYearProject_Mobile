import React from 'react'

interface Props {
  className?: string
  width?: number
  height?: number
}

export default function UserInformation({ className = "", width = 37, height = 37 }: Props) {
  return (
    <svg 
      width={width} 
      height={height} 
      viewBox="0 0 37 37" 
      fill="none" 
      xmlns="http://www.w3.org/2000/svg"
      className={className}
    >
      <path 
        d="M3.36364 4.625H33.6364V32.375H3.36364V4.625ZM1.68182 0C0.752984 0 0 1.03535 0 2.3125V34.6875C0 35.9647 0.752984 37 1.68182 37H35.3182C36.247 37 37 35.9647 37 34.6875V2.3125C37 1.03535 36.247 0 35.3182 0H1.68182ZM20.1818 9.25H30.2727V13.875H20.1818V9.25ZM28.5909 18.5H20.1818V23.125H28.5909V18.5ZM15.9773 13.875C15.9773 17.0679 14.0948 19.6562 11.7727 19.6562C9.45062 19.6562 7.56818 17.0679 7.56818 13.875C7.56818 10.6821 9.45062 8.09375 11.7727 8.09375C14.0948 8.09375 15.9773 10.6821 15.9773 13.875ZM11.7727 21.9687C8.52177 21.9687 5.88636 25.5924 5.88636 30.0625H17.6591C17.6591 25.5924 15.0237 21.9687 11.7727 21.9687Z" 
        fill="currentColor"
      />
    </svg>
  )
}